//
//  RootModel.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation
import Combine

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
    
    private lazy var userRegistrator:UserRegistrator = {
        let registrator = UserRegistrator(tokenSupplier: WeakObject(self.accessTokenSupplier),session: session)
        //subscribe to registration success for new UserId
        usersListViewModel.subscribeForNewUserId(from: registrator.registeredUserIdPublisher)
        return registrator
    }()
    
    lazy var usersListViewModel:UsersListViewModel = UsersListViewModel(loader: UsersLoader(),
                                                                        pageItemsCount: 6,
                                                                        profilePhotoCache: ImageCache.shared,
                                                                        newUserbyIdLoader: {
                                                                            UserByIdLoader(session: self.session)
                                                                        })
    
    lazy var userSignupViewModel:SignupViewModel = SignupViewModel(userPositionsLoader: UserPositionsLoader(session: self.session),
                                                                   cameraAccessHandler: CameraUsagePermissionsHandler(), userRegistrator: self.userRegistrator)
    
 
    private func getUserByIdLoader() -> UserByIdLoading {
        UserByIdLoader(session: self.session)
    }
}
