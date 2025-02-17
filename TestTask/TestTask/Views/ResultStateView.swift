//
//  SuccessStateView.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

/// Success or Failure result state view
struct ResultStateView: View {
    let success:Bool
    let message:String
    let actionTitle:String
    let primaryAtion:()->()
    let closeAction:()->()
    
    var body: some View {
            
        VStack(spacing: 20) {
            Spacer()
            Image(success ? "state_success" : "state_failure")
            Text(message).font(.regularText)
            Button(actionTitle, action: primaryAtion)
            .buttonStyle(.primaryButtonStyle)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .topTrailing) {
            Button(action:closeAction, label: {
                Image("Icon_cross")
                    .padding()
            })
        }
    }
}

extension ResultStateView {
    ///additional initializer to eliminate the need of passing `success` if it is `true`
    init(succeeded:Bool = true, message:String, actionTitle:String) {
        self.init(success: succeeded, message: message, actionTitle: actionTitle, primaryAtion: {}, closeAction: {})
    }
}

#Preview {
    ResultStateView(message: "User successfully registered", actionTitle: "Got it!")
}

#Preview {
    ResultStateView(succeeded:false, message: "That email is already registered", actionTitle: "Try again")
}
