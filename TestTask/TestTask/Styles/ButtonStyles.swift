//
//  ButtonStyle.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle:ButtonStyle {
    
    @Environment(\.colorScheme) var scheme
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration:ButtonStyle.Configuration) -> some View {
        configuration.label
            .font(.regularButton)
            .foregroundColor( isEnabled ? ( scheme == .light ? .black : .white) : Color("Button_disabled_text"))
            .padding(10)
            .padding(.horizontal, 18)
            .background(RoundedRectangle(cornerRadius: 24)
                .fill( isEnabled ? (configuration.isPressed ? Color.primaryActive : Color.primaryColor) : Color.disabledItem ))
    }
    
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    //for Static Member Lookup in Generic Contexts (https://www.avanderlee.com/swift/static-member-lookup-generic-contexts/)
    static var primaryButtonStyle:PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}


struct SecondaryButtonStyle:ButtonStyle {
    @Environment(\.colorScheme) var scheme
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration:ButtonStyle.Configuration) -> some View {
        configuration.label
            .font(.regularButton)
            .foregroundColor( isEnabled ? Color.secondaryColor : Color("Button_disabled_text"))
            .padding(10)
            .padding(.horizontal, 18)
            .background(RoundedRectangle(cornerRadius: 24)
                .fill( isEnabled ? (configuration.isPressed ? Color.secondaryColor.opacity(0.1) : Color.clear) : Color.disabledItem ))
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    //for Static Member Lookup in Generic Contexts
    static var secondaryButtonStyle:SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
}

//MARK:tests

fileprivate struct TestButtons:View {
    var body: some View {
        VStack(spacing: 24) {
            Button("Regular button", action: {
                
            })
            .buttonStyle(.primaryButtonStyle)
            
            
            Button("Disabled Button", action: {
                
            })
            .buttonStyle(.primaryButtonStyle)
            .disabled(true)
            
            Button("Secondary button") {
                
            }
            .buttonStyle(.secondaryButtonStyle)
            
            Button("Secondary disabled") {
                
            }
            .buttonStyle(.secondaryButtonStyle)
            .disabled(true)
        }
    }
}

#Preview {
    TestButtons()
}
