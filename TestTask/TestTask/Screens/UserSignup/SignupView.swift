//
//  SignupView.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

enum FocuedTextField {
    case name
    case email
    case phone
}


struct FocusedText: FocusedValueKey {
  typealias Value = Binding<String>
}

extension FocusedValues {
  var textValue: FocusedText.Value? {
    get { self[FocusedText.self] }
    set { self[FocusedText.self] = newValue }
  }
}

struct SignupView<PositionsLoader:UserPositionsLoading, CameraPermissionsChecker:CameraAccessPermissionsHandling, Reg:UserRegistration>: View {
    
    @ObservedObject var viewModel:SignupViewModel<PositionsLoader, CameraPermissionsChecker, Reg>
//    @FocusState private var focusedTextField:FocuedTextField?
    @FocusedBinding(\.textValue) var focusedTextBinding
    
    var body: some View {
        VStack(spacing:0) {
            HeaderView(title: "Working with POST request")
            ScrollView {
                VStack(spacing: 16) {
                   
                    TextInputField("Your name",
                                   text: $viewModel.nameString,
                                   isValid: $viewModel.isUserNameValid)
                        .isMandatory()
                        .onTextInputValidation(viewModel.userNameValidation)
                        .textInputAutocapitalization(.words)
                        
                    TextInputField("Email",
                                   text: $viewModel.emailString,
                                   isValid: $viewModel.isUserEmailValid)
                        .isMandatory()
                        .onTextInputValidation(viewModel.emailValidation)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    
                    TextInputField("Phone",
                                   text: $viewModel.phoneNumberString,
                                   hint:"+38 (XXX) XXX - XX - XX",
                                   isValid: $viewModel.isUserPhoneNumberValid)
                        .isMandatory()
                        .onTextInputValidation(viewModel.phoneNumberValidation)
                        .textInputAutocapitalization(.never)
                }
                .padding()
                
                positionSelectionView
                
                uploadPhotoActionView
              
                Spacer(minLength: 60) //scroll view insets, pre iOS 17
            }
        
            Button("Sign up", action: {
                viewModel.sendSignup()
            })
            .buttonStyle(.primaryButtonStyle)
            .disabled(!viewModel.isRegistrationAvailable)
            .padding(.bottom, 8)
            
        }
        .overlay(content: {
            if viewModel.isRegistrationInProgress {
                ProgressView("Registering...")
                    .progressViewStyle(.circular)
                    .foregroundStyle(.secondary)
                    .padding(36)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
            }
            
        })
        .onAppear{
            viewModel.onViewAppear()
        }
        .sheet(item: $viewModel.imageSourceType, content: {type in

            ImagePickerView(imageSource: type, imageSelected: $viewModel.selectedImage)
        })
        .confirmationDialog("Choose how you want to add a photo",
                            isPresented: $viewModel.isImageSourceDialoguePresented,
                            actions: {
            Button(action: {
                viewModel.selectSourceType(.camera)
            }, label: {
                Text("Camera")
            })
            
            Button(action: {
                viewModel.selectSourceType(.library)
            }) {
                Text("Gallery")
            }
        })
        .alert(viewModel.alertInfo?.title ?? "Error",
               isPresented: $viewModel.isAlertPresented, presenting: viewModel.alertInfo, actions: {alertInfo in
            ForEach(alertInfo.actions) {action in
                action.body
            }
        }, message: { alertInfo in
            Text(alertInfo.message ?? "")
        })
        .fullScreenCover(item: $viewModel.signupResult,
                         onDismiss: {
            
        }, content: {signupResult in
            ResultStateView(success: signupResult.success, message: signupResult.message, actionTitle: signupResult.action.title, primaryAtion: signupResult.action.work, closeAction: {
                viewModel.justDismissResultView()
            })
        })
    }
    
    @ViewBuilder private var positionSelectionView: some View {
        if viewModel.isLoadingUserPositions {
            ProgressView("Loading Positions...")
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        else {
            
            if viewModel.positionLoadingIsError {
                VStack{
                    Text(verbatim: "Positions failed to load")
                    Button(action: {
                        viewModel.retryLoadingUserPositions()
                    }, label: {Text("Retry")})
                    .buttonStyle(.secondaryButtonStyle)
                    .disabled(viewModel.isLoadingUserPositions)
                }
            }
            else {
                VStack(alignment: .leading, spacing: 16, content: {
                    SingleSelectionRadioButtonsListView(header: "Select your position", items: viewModel.availablePositions, selection: $viewModel.selectedPosition, animateSelection: true)
                })
                .padding()
            }
            
        }
    }
    
    @ViewBuilder private var uploadPhotoActionView: some View {
        RoundedRectangle(cornerRadius: 4.0, style: .circular)
            .stroke(Color.secondaryInactive, lineWidth: 1.0)
            .frame(height:56)
            .overlay(content: {
                HStack(content: {
                    Text("Upload your photo")
                        .body2TextStyle(secondary: true)
                    Spacer()
                    Button(action: {
                        viewModel.startPhotoSelection()
                    }, label: {
                        Text("Upload")
                    })
                    .buttonStyle(.secondaryButtonStyle)
                })
                .padding(.horizontal)
            })
            .padding(.horizontal)
            
    }
}

#Preview {
//    SignupView(viewModel: SignupViewModel<UserPositionsLoader>(userPositionsLoader: UserPositionsLoader()))
    
    SignupView(viewModel: SignupViewModel(userPositionsLoader: UserPositionsDummy(),
                                          cameraAccessHandler: CameraAccessPermissionsDummy(),
                                          userRegistrator: UserRegistrationDummy(succeeding: false)))
}
