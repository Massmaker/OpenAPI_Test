//
//  TextInputModifier.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import Foundation
import SwiftUI

fileprivate struct InputExternalValidatorModifier<Validator:StringInputValidation>:ViewModifier {
    let validator:Validator
    @Binding var text:String
    @FocusState private var isFocused:Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let isValid = isFocused ? true : validator.validate(text)
            
            RoundedRectangle(cornerRadius: 4, style: RoundedCornerStyle.circular)
                .stroke(isFocused ? Color.secondaryColor : (isValid ? Color.buttonSecondaryInactive : Color.errorItem) , lineWidth: 1)
            
            content
                .focused($isFocused)
                .foregroundStyle(isValid ? Color.primary : Color.errorItem)
                .padding(.horizontal)
                
        }
    }
}

fileprivate extension View {
    func validate(with validator: some StringInputValidation, text:Binding<String>) -> some View {
        modifier(InputExternalValidatorModifier(validator: validator, text: text))
    }
}


extension View {
    /// validating input text after putting it to the lower case
    func validatingEmail(_ text:Binding<String>) -> some View {
        validate(with: EmailStringValidator(), text: text)
    }
    
    func validatingPhoneNumber(_ text:Binding<String>) -> some View {
        validate(with: PhoneNumberValidator(), text: text)
    }
    
    func validatingUserName(_ text:Binding<String>) -> some View {
        validate(with: UserNameValidator(), text: text)
    }
    
    func validationDisabled(for text:Binding<String>) -> some View {
        validate(with: AlwaysSucceedingStringValidator(), text: text)
    }
}

