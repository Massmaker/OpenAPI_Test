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

struct SignupView<PositionsLoader:UserPositionsLoading>: View {
    
    @ObservedObject var viewModel:SignupViewModel<PositionsLoader>
//    @FocusState private var focusedTextField:FocuedTextField?
    @FocusedBinding(\.textValue) var focusedTextBinding
    
    var body: some View {
        VStack(spacing:0) {
            HeaderView(title: "Working with POST request")
            ScrollView {
                VStack(spacing: 16) {
                    BorderedTextInputView(text: $viewModel.nameString, validationType: .name(prompt: "Your name"))
//                        .focusedValue(\.textValue, $focusedTextBinding)
//                        .focused($focusedTextField, equals: .name)
                        
                    
                    BorderedTextInputView(text: $viewModel.emailString, validationType: .email)
//                        .focused($focusedTextField, equals: .email)
                    
                    BorderedTextInputView(text: $viewModel.phoneNumberString, validationType: .phoneNumber)
//                        .focused($focusedTextField, equals: .phone)
                }
                .padding()
                
                positionSelectionView
                
            }
                    
            
            Button("Sign up", action: {
                viewModel.sendSignup()
            })
            .buttonStyle(.primaryButtonStyle)
            .disabled(!viewModel.isSignupEnabled)
            .padding(.bottom, 8)
            
        }
        .onAppear{
            viewModel.onViewAppear()
        }
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
}

#Preview {
//    SignupView(viewModel: SignupViewModel<UserPositionsLoader>(userPositionsLoader: UserPositionsLoader()))
    
    SignupView(viewModel: SignupViewModel(userPositionsLoader: UserPositionsDummy()))
}
