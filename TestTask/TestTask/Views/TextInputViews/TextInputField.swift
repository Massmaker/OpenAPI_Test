//
//  TextInputField.swift
//  TestTask
//
//  Created by Ivan_Tests on 13.02.2025.
//

import Foundation
import SwiftUI

fileprivate let kScaleDownValue:CGFloat = 0.75
fileprivate let kTitleLabelVerticalOffset:CGFloat = -20.0
fileprivate let kActiveTextFieldVerticalOffset:CGFloat = 8.0
fileprivate let kSubtitleLabelVerticalOffset:CGFloat = 42.0

struct TextInputField:View {
    private var title:String
    private var hint:String?
    
    @Binding private var text:String
    @Binding private var isValidBinding:Bool
    @FocusState private var isTextFieldFocused:Bool
    @State var validationMessage:String = ""
    @State private var isValid:Bool = true {
        didSet {
            isValidBinding = isValid
        }
    }
    
    @Environment(\.isMandatory) var isMandatory
    @Environment(\.textInputValidationHandler) var inputValidator
    
    
    init(_ title:String,
         text:Binding<String>,
         hint:String? = nil,
         isValid validationBinding:Binding<Bool>? = nil) {
        
        self.title = title
        self._text = text
        
        if let hint, !hint.isEmpty {
            self.hint = hint
        }
        
        if let validBind = validationBinding {
            self._isValidBinding = validBind
        }
        else {
            self._isValidBinding = .constant(true)
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading, content: {
            RoundedRectangle(cornerRadius: 4, style: .circular)
                .stroke(borderStrokeColor, lineWidth: 1)
                .frame(height: 56)
            
            //support message label (error state)
            
            subtitleTextIfNeeded
                .padding(.leading, 16)
                .offset(y: kSubtitleLabelVerticalOffset)
            
            titleLabel
                .padding(.leading, 16)
            
            textField
                .offset(y:textFieldOffset())
                .padding(.leading, 16)
            
        })
        .padding(.top, 16)
        .animation(.linear(duration: 0.2), value: isTextFieldFocused)
        .onAppear {
            //validate(text)
        }
        .onChange(of: text) {newValue in
            if isTextFieldFocused {
                return
            }
            validate(newValue)
        }
        .onChange(of: isTextFieldFocused) {isFocused in
            if !isFocused {
                validate(text)
            }
        }

    }
      
    @ViewBuilder private var subtitleTextIfNeeded: some View {
        if !isValid {
            Text(validationMessage)
                .subtitleErrorTextStyle()
                
        }
        else if let hint, text.isEmpty {
            Text(hint)
                .subtitleTextInputStyle(secondary: true)
        }
    }
    
    @ViewBuilder
    private var textField: some View {
        TextField("", text: $text)
            .font(.regularText)
            .focused($isTextFieldFocused)
            //.offset(y: title.isEmpty ? 0 : (isTextFieldFocused ? 8 : 0))
    }
    
    private var borderStrokeColor:Color {
        
        if isTextFieldFocused {
            if isValid {
                Color.secondaryColor
            }
            else {
                Color.errorItem
            }
        }
        else {
            
            if !isValid {
                Color.errorItem
            }
            else {
                Color.secondaryInactive
            }
        }
    }
    
    private var titleLabelColor:Color {
        if isTextFieldFocused {
            if !isValid {
                Color.errorItem
            }
            else {
                Color.secondaryColor
            }
        }
        else {
            if !isValid {
                Color.errorItem
            }
            else {
                Color.secondaryInactive
            }
        }
    }
    
    @ViewBuilder private var titleLabel: some View {
        if title.isEmpty {
            EmptyView()
        }
        
        Text(title)
                .font(.regularText)
                .foregroundColor(titleLabelColor)
                .offset(y: titleLabelOffset())
                .scaleEffect(isTextFieldFocused ? kScaleDownValue : text.isEmpty ? 1.0 : kScaleDownValue, anchor: .leading)
        
    }
    
    fileprivate func textFieldOffset() -> CGFloat {
        if title.isEmpty {
            return 0
        }
        
        if isTextFieldFocused {
            return kActiveTextFieldVerticalOffset
        }
        else {
            if text.isEmpty {
                return 0
            }
            else {
                return kActiveTextFieldVerticalOffset
            }
        }
    }
    
    
    fileprivate func titleLabelOffset() -> CGFloat {
        if title.isEmpty {
            return 0
        }
        
        if isTextFieldFocused {
            return kTitleLabelVerticalOffset
        }
        else {
            if text.isEmpty {
                return 0
            }
            return kTitleLabelVerticalOffset
        }
    }
    
    fileprivate func validate(_ value:String) {
        if isMandatory {
            isValid = !value.isEmpty
            validationMessage = isValid ? "" : "Required field"
        }
        
        if isValid {
            guard let externalValidaror = self.inputValidator else {
                return
            }
            
            let validationResult = externalValidaror(value)
            
            switch validationResult{
            case .failure(let validationError):
                self.validationMessage = "\(validationError.localizedDescription)"
                self.isValid = false
            case .success(let isValidCheck):
                self.isValid = isValidCheck
                self.validationMessage = ""
            }
        }
    }
}

//MARK: - Animation of state
//struct TextInputViewAnimation:Animation {
//    
//}

//MARK: - Previews
@available(iOS 17, *)
#Preview {

    @Previewable @State var editedText1:String = ""
    @Previewable @State var editedText2:String = ""
    @Previewable @State var emailValid:String = "name.sirname@email.com"
    @Previewable @State var emailInvalid:String = "invalid.email.com"
    
    let emailValidator = EmailStringValidator()
    let phoneValidator = PhoneNumberValidator()
    
    VStack{
     
        TextInputField("Name", text: $editedText1)
        
        TextInputField("Phone", text: $editedText2, hint: "+38 (XXX) XXX - XX - XX")
            .isMandatory()
            .onTextInputValidation { phoneString in
                let isPhoneValid = phoneValidator.validate(phoneString)
                if !isPhoneValid {
                    return .failure(.invalidPhoneNumber(message: "Invalid phone number format"))
                }
                else {
                    return .success(true)
                }
            }
        
        TextInputField("Email valid", text: $emailValid)
            .isMandatory()
            .onTextInputValidation({ textToValidate in
                let isValidEmail = emailValidator.validate(textToValidate)
                if !isValidEmail {
                    return .failure(.invalidEmail(message: "Invalid email format"))
                }
                else {
                    return .success(true)
                }
            })
           
        
        TextInputField("Email errors", text: $emailInvalid)
            .isMandatory()
            .onTextInputValidation({ textToValidate in
                let isValidEmail = emailValidator.validate(textToValidate)
                if !isValidEmail {
                    return .failure(.invalidEmail(message: "Invalid email format"))
                }
                else {
                    return .success(true)
                }
            })
    }.padding()
}

//MARK: - Environment Variables

//MARK: -
//MARK: - Mandatory

fileprivate struct InputFieldMandatory: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var isMandatory:Bool {
        get {
            self[InputFieldMandatory.self]
        }
        
        set {
            self[InputFieldMandatory.self] = newValue
        }
    }
}

extension View {
    func isMandatory( _ value:Bool = true) -> some View {
        self.environment(\.isMandatory, value)
    }
}

//MARK: - External Validation
fileprivate struct TextInputExternalValidation: EnvironmentKey {
    static var defaultValue: ((String) -> Result<Bool, TextInputValidationError>)?
}

extension EnvironmentValues {
    var textInputValidationHandler:((String) -> Result<Bool, TextInputValidationError>)? {
        get {
            self[TextInputExternalValidation.self]
        }
        set {
            self[TextInputExternalValidation.self] = newValue
        }
    }
}

extension View {
    func onTextInputValidation(_ handler: @escaping (String) -> Result<Bool, TextInputValidationError> ) -> some View {
        environment(\.textInputValidationHandler, handler)
    }
}


//MARK: -

