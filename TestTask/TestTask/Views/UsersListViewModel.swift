//
//  UsersListViewModel.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation

@MainActor
final class UsersListViewModel<Loader>:ObservableObject where Loader:Pageable, Loader.Value == User {
    
    enum LoadingStatus {
        
        case idle
        case loadingFirstPage
        case loadingNextPage
        case error( any Error)
    }
    
    private let usersSource: Loader
    private(set) var pageSize:Int
    private var currentPage:PageInfo = .default
    
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
    
    @Published private(set) var users:[User] = []
    @Published private(set) var isLoading:Bool = false
    
    var lastApearedUserIndex:Int = 0
    
    private var currentTask:Task<Void,Never>? {
        willSet {
            if let current = currentTask, !current.isCancelled {
                current.cancel()
            }
        }
    }
    
    init(loader: Loader, pageItemsCount:Int) {
        self.usersSource = loader
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
            var items:[User] = self.users + receivedUsers
    
            items.sort {
                $0.registrationTimestamp < $1.registrationTimestamp
            }
            
            DispatchQueue.main.async(execute: {[weak self] in
                guard let self else { return }
                self.users = items
                loadingState = .idle
            })
        }
        catch {
            
        }
    }
}
