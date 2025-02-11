//
//  SignupView.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

struct SignupView: View {
    
    @ObservedObject var viewModel:SignupViewModel<UserPositionsLoader>
    
    var body: some View {
        VStack(spacing:0) {
            HeaderView(title: "Working with POST request")
            
            
            positionSelectionView
                    
            
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
    SignupView(viewModel: SignupViewModel<UserPositionsLoader>(userPositionsLoader: UserPositionsLoader()))
}
