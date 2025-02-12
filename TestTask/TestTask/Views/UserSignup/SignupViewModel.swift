//
//  SignupViewModel.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import Foundation
import UIKit
import Combine


@MainActor
final class SignupViewModel<PositionsLoader:UserPositionsLoading, CameraPermissionsChecker:CameraAccessPermissionsHandling>: ObservableObject {
    
    @Published var selectedPosition:UserPosition?
    @Published private(set) var availablePositions:[UserPosition] = []
    @Published var positionLoadingIsError:Bool = false
    @Published private(set) var isLoadingUserPositions:Bool = false
    @Published var nameString:String = ""
    @Published var emailString:String = ""
    @Published var phoneNumberString:String = ""
    @Published private(set) var isSignupEnabled:Bool = false
    
    @Published var isImageSourceDialoguePresented:Bool = false
    
    @Published var imageSourceType:ImageSourceType?
    
    var alertInfo:AlertInfo? {
        didSet {
            if let _ = alertInfo, !isAlertPresented {
                isAlertPresented = true
            }
        }
    }
    
    var isAlertPresented:Bool = false {
        willSet {
            if newValue != isAlertPresented {
                objectWillChange.send()
            }
        }
        didSet {
            if !isAlertPresented, let _ = alertInfo {
                alertInfo = nil
            }
        }
    }
    
    var selectedImage:UIImage? {
        didSet {
            guard let image = selectedImage else {
                return
            }
            processImage(image)
        }
    }
    
    //private var imageSourceTypeSelectionSUbscription:AnyCancellable?
    
    private var profileImageData:Data?
    
    private let userPositionsLoader:PositionsLoader
    private let cameraPermissionsHandler:CameraPermissionsChecker
    
    init(selectedPosition: UserPosition? = nil, availablePositions: [UserPosition] = [], userPositionsLoader: PositionsLoader, cameraAccessHandler:CameraPermissionsChecker) {
        self.selectedPosition = selectedPosition
        self.availablePositions = availablePositions
        self.userPositionsLoader = userPositionsLoader
        
        self.cameraPermissionsHandler = cameraAccessHandler
    }
    
    private func loadUserPositions() {
        print("Loading User Positions")
        
        self.isLoadingUserPositions = true
        
        Task {[weak self] in
            guard let self else {
                return
            }
            
            do {
                let sortedPositions = try await self.userPositionsLoader.getUserPositions()
                self.availablePositions = sortedPositions
            }
            catch {
                self.positionLoadingIsError = true
            }
            print("Loading User Positions finished")
            self.isLoadingUserPositions = false
            
        }
    }
    
    //MARK: - UI Actions
    func onViewAppear() {
        if !isLoadingUserPositions, availablePositions.isEmpty {
            loadUserPositions()
        }
    }
    
    func selectPosition(_ position:UserPosition) {
        self.selectedPosition = position
    }
    
    func selectSourceType(_ type:ImageSourceType) {
        if case .camera = type {
            Task {[type, weak self] in
                do {
                    try await self?.cameraPermissionsHandler.checkCameraAccessPermissions()
                    self?.imageSourceType = type
                }
                catch {
                    // handle error requesting cameraAccess permissions
                    if let accessError = error as? CameraAccessError {
                        
                        switch accessError {
                            
                        case .permissionError(let authorizationStatusError):
                            
                            switch authorizationStatusError {
                                
                            case .denied:
                                
                                self?.displayAlert(title: "Permissions error",
                                             message: "Camera access requires permission from user, please allow access in Settings",
                                             targetAction: AlertAction.goToSettings)
                                
                            case .restricted:
                                self?.displayAlert(title: "Permissions error", message: "Camera access permission is restricted. Cannot use Camera to take profile photo.", targetAction: nil)
                            }
                        
                        case .unsupported:
                            self?.displayAlert(title: "Camera Unsupported", message: "It seems that this device does not support taking pictures with camera", targetAction: nil, dismissAction: AlertAction.cancel)
                        }
                    }
                    return
                }
            }
        }
        else {
            self.imageSourceType = type
        }
    }
    
    func retryLoadingUserPositions() {
        if isLoadingUserPositions {
            return
        }
        
        loadUserPositions()
    }
    
    func startPhotoSelection() {
        self.isImageSourceDialoguePresented = true
    }
    
    func sendSignup() {
        
    }
    
    //MARK: -
    private func processImage(_ image:UIImage) {
        let validator = UserProfileImageValidator()
        let isValid = validator.validate(image)
        if isValid {
            self.profileImageData = image.jpegData(compressionQuality: 1.0)
        }
        else {
            self.profileImageData = nil
        }
        
        //cleanup
        self.selectedImage = nil
    }
    
    //MARK: - Error alerts
    
    private func displayAlert(title:String, message:String, targetAction:AlertAction?, dismissAction:AlertAction = AlertAction.cancel) {
        
        if let targetAction {
            self.alertInfo = AlertInfo(title: title, message: message, actions: [targetAction, dismissAction])
        }
        else {
            self.alertInfo = AlertInfo(title: title, message: message, actions: [dismissAction])
        }
    }
}


