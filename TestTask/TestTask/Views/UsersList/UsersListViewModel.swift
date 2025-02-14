//
//  UsersListViewModel.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation
import UIKit
import OSLog

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
    
    var lastApearedUserIndex:Int = 0
    
    private var currentTask:Task<Void,Never>? {
        willSet {
            if let current = currentTask, !current.isCancelled {
                current.cancel()
            }
        }
    }
    
    init(loader: Loader, pageItemsCount:Int, profilePhotoCache: AvatarCache) {
        self.usersSource = loader
        self.imageCache = profilePhotoCache
        
        pageSize = pageItemsCount
    }
    
    func onViewAppear() {
        if users.isEmpty {
//            let response = try await usersSource.loadPage(after: currentPage, size: pageSize)
            currentPage = PageInfo(hasNext: true, nextCursor: API.getUsers(page: 1, size: pageSize).requestURL())
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
    
    private func loadMoreUsers() async {
        do {
            let response = try await usersSource.loadPage(after: currentPage, size: pageSize)
            
            if Task.isCancelled {
                return
            }
            
            let receivedUsers = response.items
            let pageInfo = response.pageInfo
            self.currentPage = pageInfo
            var items:[UserUIInfo] = self.users + receivedUsers.map({UserUIInfo(user: $0)})
    
            items.sort {
                $0.registrationTimestamp < $1.registrationTimestamp
            }
            
            DispatchQueue.main.async(execute: {[weak self] in
                guard let self else { return }
                logger.notice("Updating with new users")
                self.users = items
                loadingState = .idle
            })
            
            //start obtaining profile avatars for new users
            
            
            receivedUsers
                .filter{$0.photo != nil}
                .map{
                    (userId: $0.id, imageURLString:$0.photo!)
                }
                .forEach { (userId, photoURLString) in
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
            
        }
        catch {
            
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
}
