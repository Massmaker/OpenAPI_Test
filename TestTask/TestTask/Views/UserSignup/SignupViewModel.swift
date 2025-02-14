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
    @Published var emailString:EmailString = ""
    @Published var phoneNumberString:PhoneNumber = ""
    
    @Published var isUserNameValid:Bool = false
    @Published var isUserEmailValid:Bool = false
    @Published var isUserPhoneNumberValid:Bool = false
    @Published var isRegistrationAvailable:Bool = false
    
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
    private var cancellables:Set<AnyCancellable> = []
    private lazy var profileImageDataCurrentValue:CurrentValueSubject<Data?, Never> = .init(nil)
    
    
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
        
        
        let roleSelectionValidPublisher = $selectedPosition
            .map {
                let isRoleSelected:Bool = $0 != nil
                
                return isRoleSelected
            }
            .eraseToAnyPublisher()
            
        
        let imageDataValidPublisher = profileImageDataCurrentValue
            .map {
                return $0 != nil
            }
            .eraseToAnyPublisher()
            
        let textInputPublishers =
        Publishers.CombineLatest3($isUserNameValid.eraseToAnyPublisher(),
                                  $isUserEmailValid.eraseToAnyPublisher(),
                                  $isUserPhoneNumberValid.eraseToAnyPublisher())
        .map{
            $0 && $1 && $2
        }
        .eraseToAnyPublisher()
        
       
        
        let registrationPublisher =
        Publishers.CombineLatest3(roleSelectionValidPublisher, imageDataValidPublisher, textInputPublishers)
            .map{
                $0 && $1 && $2
            }
            .eraseToAnyPublisher()
        
        
        registrationPublisher
            .removeDuplicates()
            .sink(receiveValue: {[unowned self] isAvailable in
                self.isRegistrationAvailable = isAvailable
            })
            .store(in: &cancellables)
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
    func userNameValidation(_ name:String) -> Result<Bool, TextInputValidationError> {
        
        if name.isEmpty {
            return .failure(.invalidName(message:"Required field"))
        }
        
        let isValid = UserNameValidator().validate(name)
        
        if isValid {
            return .success(true)
        }
        else {
            return .failure(TextInputValidationError.invalidName(message: "Invalid name"))
        }
    }
    
    func emailValidation(_ email:EmailString) -> Result<Bool, TextInputValidationError> {
        
        if email.isEmpty {
            return .failure(.invalidName(message:"Required field"))
        }
        
        let isEmailValid = EmailStringValidator().validate(email)
        
        if isEmailValid {
            return .success(true)
        }
        else {
            return .failure(TextInputValidationError.invalidName(message: "Invalid email format"))
        }
    }
    
    func phoneNumberValidation(_ phone:PhoneNumber) -> Result<Bool, TextInputValidationError> {
        if phone.isEmpty {
            return.failure(.invalidName(message:"Required field"))
        }
        
        let isPhoneValid = PhoneNumberValidator().validate(phone)
        
        if isPhoneValid {
            return .success(true)
        }
        else {
            return .failure(TextInputValidationError.invalidName(message: "Invalid phone nmber format"))
        }
    }
    
    //MARK: -
    private func processImage(_ image:UIImage) {
        let validator = UserProfileImageValidator()
        let isValid = validator.validate(image)
        
        if isValid, let imageData = image.jpegData(compressionQuality: 1.0) {
            self.profileImageDataCurrentValue.send(imageData)
        }
        else {
            self.profileImageDataCurrentValue.send(nil)
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


