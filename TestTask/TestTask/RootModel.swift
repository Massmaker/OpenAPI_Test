//
//  RootModel.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation

@MainActor
final class RootModel:ObservableObject {
    var usersListViewModel:UsersListViewModel = UsersListViewModel(loader: UsersLoader(), pageItemsCount: 6)
    
    let imageCache = ImageCache.shared
 
}
