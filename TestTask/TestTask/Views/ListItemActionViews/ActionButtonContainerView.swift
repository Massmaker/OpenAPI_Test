//
//  ActionButtonContainerView.swift
//  TestTask
//
//  Created by Ivan_Tests on 17.02.2025.
//

import SwiftUI

struct ActionButtonContainerView: View {
    
    var isValid:Bool
    let title:String
    let actionTitle:String
    let action:()->()
    var validationText:String? = nil
    
    @Environment(\.isMandatory) var isMandatory
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4.0, style: .circular)
            .stroke(isValid ? Color.secondaryInactive : Color.errorItem, lineWidth: 1.0)
            .frame(height:56)
            .overlay(content: {
                HStack(content: {
                    if isMandatory, !isValid {
                        Text(title)
                            .body3TextStyle(error: true)
                            .foregroundStyle(Color.errorItem)
                    }
                    else {
                        Text(title)
                            .body2TextStyle(secondary: true)
                    }
                    Spacer()
                    Button(action: action, label: {
                        Text(actionTitle)
                    })
                    .buttonStyle(.secondaryButtonStyle)
                })
                .padding(.horizontal)
                
                if isMandatory, !isValid, let subtitle = validationText {
                    HStack {
                        Text(subtitle)
                            .subtitleErrorTextStyle()
                            .padding(.leading)
                        Spacer()
                    }
                    .offset(y: 42)
                        
                }
            })
        
        
    }
}

#Preview {
    VStack {
        ActionButtonContainerView(isValid: true, title: "Upload your photo", actionTitle: "Upload", action: { }, validationText: "Required item subtitle text")
            .isMandatory()
        Divider()
        ActionButtonContainerView(isValid: false, title: "Upload your photo", actionTitle: "Upload", action: { }, validationText: "Required item subtitle text")
            .isMandatory()
    }
    .padding(.horizontal)
    
}
