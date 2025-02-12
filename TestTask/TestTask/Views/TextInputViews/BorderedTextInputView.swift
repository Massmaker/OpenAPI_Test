//
//  BorderedTextInputView.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import SwiftUI

enum TextValidationType {
    case validationDisabled(prompt:String?)
    case name(prompt:String? = nil)
    case email
    case phoneNumber
}




struct BorderedTextInputView: View {
    
    @Binding var text:String
    
    @State private var pText:String
    private let validationType:TextValidationType
    
    
    init(text:Binding<String>, validationType:TextValidationType = .validationDisabled(prompt:nil)) {
        
        self._text = text
        self.pText = text.wrappedValue
        self.validationType = validationType
    }
    
    var body: some View {
        
        textField
            
            .frame(height:50)
            .onChange(of: pText, perform: {newValue in
                text = newValue
            })
       
    }
    
    @ViewBuilder private var textField: some View {
        switch validationType {
        case .name(let prompt):
            TextField(prompt ?? "", text: $pText)
                .validatingUserName($pText)
        case .email:
            TextField("Email", text: $pText)
                .validatingEmail($pText)
        case .phoneNumber:
            TextField("Phone", text: $pText)
                .validatingPhoneNumber($pText)
        case .validationDisabled(let prompt):
            TextField(prompt ?? "", text: $pText)
                .validationDisabled(for: $pText)
                
        }
    }
}

#Preview {
    BorderedTextInputView(text: .constant("380974027438"), validationType: .phoneNumber)
}
