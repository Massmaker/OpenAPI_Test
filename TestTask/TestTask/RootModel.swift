//
//  RootModel.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation

@MainActor
final class RootModel:ObservableObject {
    
    let imageCache = ImageCache.shared
    
    lazy var usersListViewModel:UsersListViewModel = UsersListViewModel(loader: UsersLoader(),
                                                                        pageItemsCount: 6,
                                                                        profilePhotoCache: ImageCache.shared)
    
    lazy var userSignupViewModel:SignupViewModel = SignupViewModel(userPositionsLoader: UserPositionsLoader(),
                                                                   cameraAccessHandler: CameraUsagePermissionsHandler())
    
 
}
