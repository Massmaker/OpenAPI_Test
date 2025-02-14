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
    
    private lazy var session:URLSession = {
        let s = URLSession(configuration: .default)
        return s
    }()
    
    private lazy var accessTokenSupplier:UserAccessTokenSupplier = {
        UserAccessTokenSupplier(session: session)
    }()
    
    
    lazy var usersListViewModel:UsersListViewModel = UsersListViewModel(loader: UsersLoader(),
                                                                        pageItemsCount: 6,
                                                                        profilePhotoCache: ImageCache.shared)
    
    lazy var userSignupViewModel:SignupViewModel = SignupViewModel(userPositionsLoader: UserPositionsLoader(session: self.session),
                                                                   cameraAccessHandler: CameraUsagePermissionsHandler(), userRegistrator: UserRegistrator(tokenSupplier: WeakObject(self.accessTokenSupplier), session: session))
    
 
    private func getUserByIdLoader() -> UserByIdLoading {
        UserByIdLoader(session: self.session)
    }
}
