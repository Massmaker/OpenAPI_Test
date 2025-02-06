//
//  RootModel.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation

final class RootModel:ObservableObject {
    var usersListViewModel:UsersListViewModel
    
    let imageCache = ImageCache()
    
    init() {
        usersListViewModel = UsersListViewModel()
    }
}
