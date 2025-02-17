//
//  UsersListViewModel.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation
import UIKit
import OSLog
import Combine

#if DEBUG
fileprivate let logger = Logger(subsystem: "ViewModels", category: "UsersListViewModel")
#else
fileprivate let logger = Logger(.disabled)
#endif

@MainActor
final class UsersListViewModel<Loader, AvatarCache:DataForURLCache>:ObservableObject where Loader:Pageable, Loader.Value == User {
    
    enum LoadingStatus {
        
        case idle
        case loadingFirstPage
        case loadingNextPage
        case error( any Error)
    }
    
    private let usersSource: Loader
    private(set) var pageSize:Int
    private var currentPage:PageInfo = .default
    
    let imageCache: AvatarCache
    
    private(set) var loadingState:LoadingStatus = .idle {
        didSet {
            switch loadingState {
            case .loadingNextPage, .loadingFirstPage:
                isLoading = true
            default:
                isLoading = false
            }
        }
    }
    
    
    private var avatarTasks:[String:Task<Void, Never>] = [:]
    
    @Published private(set) var users:[UserUIInfo] = []
    @Published private(set) var isLoading:Bool = false
    
    private var currentTask:Task<Void,Never>? {
        willSet {
            if let current = currentTask, !current.isCancelled {
                current.cancel()
            }
        }
    }
    
    private var newUserIdCancellable:AnyCancellable?
    
    private var userByIdLoaderFunction: (() -> any UserByIdLoading)
    
    //MARK: -
    
    init(loader: Loader, pageItemsCount:Int, profilePhotoCache: AvatarCache, newUserbyIdLoader supplierFunction: @escaping () -> some UserByIdLoading ) {
        self.usersSource = loader
        self.imageCache = profilePhotoCache
        self.userByIdLoaderFunction = supplierFunction
        pageSize = pageItemsCount
    }
    
    func onViewAppear() {
        
        
        if users.isEmpty {

            let firstUsersPagePath:String = API.getUsers(page: 1, size: pageSize)
                                                .requestPath()
            
            currentPage = PageInfo(hasNext: true,
                                   nextCursor:firstUsersPagePath)
            
            loadingState = .loadingFirstPage
            
            currentTask = Task {
                await loadMoreUsers()
            }
        }
        
    }
    
    func onUserAppear(_ id:UserId) {
        
        
        if !canLoadMore() {
            return
        }
        
        if case .loadingFirstPage = loadingState {
            return
        }
        
        if case .loadingNextPage = loadingState {
            return
        }
        
        guard let index = users.firstIndex(where: {$0.id == id}) else {
            return
        }
        
        
        if index == (users.count - 1) {
            loadingState = .loadingNextPage
            currentTask = Task {
                await loadMoreUsers()
            }
        }
    }
    
    func userProfileImage(for user:User) async -> UIImage? {
        
        guard let linkString = user.photo else {
            return nil
        }
        
        guard let imageData = await self.imageCache.readData(forLink: linkString) else {
            return nil
        }
        
        guard let uiImage = UIImage(data: imageData) else {
            return nil
        }
        
        return uiImage
    }
    
    private func canLoadMore() -> Bool {
        currentPage.hasNext
    }
    
    fileprivate func startLoadingAvatarFor(_ photoURLString: UserPhotoLink, _ userId: UserId) {
        logger.notice("postponing the Image data loading")
        let imageTask =  Task {[weak self] in
            guard let self else {
                return
            }
            
            if let imageData = await imageCache.readData(forLink:  photoURLString) {
                logger.notice("Updating with image data \(imageData.count) bytes")
                self.updateAvatar(by: userId, with: imageData)
            }
        }
        
        self.avatarTasks[photoURLString] = imageTask
    }
    
    private func loadMoreUsers() async {
        do {
            let response = try await usersSource.loadPage(after: currentPage, size: pageSize)
            
            if Task.isCancelled {
                return
            }
            
            let receivedUsers = response.items
            let pageInfo = response.pageInfo
            self.currentPage = pageInfo
            
            let items:[UserUIInfo] = receivedUsers
                .map({UserUIInfo(user: $0)})
                .sorted { $0.registrationTimestamp < $1.registrationTimestamp }
            
            
            DispatchQueue.main.async(execute: {[weak self] in
                guard let self else { return }
                logger.notice("Updating with new users")
                self.users += items
                loadingState = .idle
            })
            
            //start obtaining profile avatars for new users
            
            
            receivedUsers
                .filter{$0.photo != nil}
                .map{
                    (userId: $0.id, imageURLString:$0.photo!)
                }
                .forEach { (userId, photoURLString) in
                    startLoadingAvatarFor(photoURLString, userId)
                }
            
        }
        catch (let error){
            if let apiError = error as? APICallError {
                if case .reasonableMessage(_ , let handledErrorStatusCode) = apiError {
                    if case .notFound = handledErrorStatusCode {
                        currentPage = PageInfo(hasNext: false, nextCursor: nil)
                        DispatchQueue.main.async {[unowned self] in
                            loadingState = .idle
                        }
                    }
                }
            }
        }
    }
    
    private func updateAvatar(by userId:UserId, with data:Data) {
        guard let uiImage = UIImage(data:data) else {
            return
        }
        
        guard let firstIndex = self.users.firstIndex(where: {$0.id == userId}) else {
            return
        }
        
        self.users[firstIndex].profileImage = uiImage
    }
    
    //MARK: - User Registration new UserId handling
    
    func subscribeForNewUserId(from publisher: some Publisher<UserId, Never>) {
        newUserIdCancellable =
        publisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] newUserId in
                guard let self else { return }
                self.users.removeAll(keepingCapacity: true)
//                self.currentPage = .init(hasNext: true, nextCursor: API.getUsers(page: 1, size: 6).requestPath())
//                Task {[weak self] in
//                    await self?.loadMoreUsers()
//                }
            }
        
    }
}
