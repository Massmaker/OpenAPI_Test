//
//  TextInputModifier.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import Foundation
import SwiftUI

struct TextInputValidationModifier:ViewModifier {
    
    let validation:(String) -> Bool
    @Binding var text:String
    
    func body(content:Content) -> some View {
        ZStack {
            let isValid = validation(text)
            
            RoundedRectangle(cornerRadius: 4, style: RoundedCornerStyle.circular)
                    .stroke( isValid ? Color.buttonSecondaryInactive : Color.errorItem , lineWidth: 1)
            
            content
                .foregroundStyle(isValid ? Color.primary : Color.errorItem)
                .padding(.horizontal)
                
        }
        
    }
}


fileprivate extension TextField {
    func validatedWith(_ validator: @escaping (String) -> Bool, text: Binding<String>) -> some View {
        modifier(TextInputValidationModifier(validation: validator, text: text))
    }
}

/// Email regex taken from https://regexr.com/2rhq7
fileprivate let kEmailRegex:String = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"

fileprivate let kPhoneNumberRegex:String = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"

let kImageDataSizeMaxValue:Int = 5_242_880 //5MegaBytes

extension TextField {
    /// validating input text after putting it to the lower case
    func validatingEmail(_ text:Binding<String>) -> some View {
        validatedWith({input in
            input.lowercased().matchesRegex(kEmailRegex)
        }, text: text)
    }
    
    func validatingPhoneNumber(_ text:Binding<String>) -> some View {
        validatedWith({ input in
            input.matchesRegex(kPhoneNumberRegex)
        }, text: text)
    }
    
    func validatingUserName(_ text:Binding<String>) -> some View {
        validatedWith({ input in
            input.count > 1 && input.count < 61
        }, text: text)
    }
}


//MARK: - Focused TextField modifier

struct FocusedTextFieldModifier:ViewModifier {
    
    @Environment(\.isFocused) private var isViewFocused
    
    func body(content:Content) -> some View {
        if isViewFocused {
            ZStack {
                RoundedRectangle(cornerRadius: 4, style: RoundedCornerStyle.circular)
                    .stroke( Color.secondaryColor, lineWidth: 1)
                
                content
                    .foregroundStyle(Color.primary)
                    .padding(.horizontal)
                    
            }
        }
        else {
            content
        }
    }
}

extension View {
    func roundedBorderFocusedView() -> some View {
        modifier(FocusedTextFieldModifier())
    }
}
