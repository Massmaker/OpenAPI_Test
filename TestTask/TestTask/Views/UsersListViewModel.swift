//
//  UsersListViewModel.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation

final class UsersListViewModel:ObservableObject {
    @Published private(set) var users:[UserInfo] = []
    @Published private(set) var isLoading:Bool = false
    
}
