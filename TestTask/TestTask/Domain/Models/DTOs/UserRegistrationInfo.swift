//
//  UserRegistrationInfo.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import Foundation

//MARK: - Response data
struct UserRegistrationResponse:Decodable {
    let success:Bool
    let userId: UserId //Int
    var message:String?
}


//MARK: - Request data
struct UserRegistrationRequestInfo {
    
    let name:String
    let email:String
    let phone:String
    let positionId:Int
    let photo:Data
}


protocol MultipartFormDataEncodable {
    var formFields:[String:String] {get}
    var fileDataInfo:FormFileDataInfo {get}
}

extension UserRegistrationRequestInfo: MultipartFormDataEncodable {
    var formFields: [String : String] {
        return ["name":name, "email":email, "phone":phone, "position_id":"\(positionId)"]
    }
    
    var fileDataInfo: FormFileDataInfo {
        FormFileDataInfo(data: photo)
    }
}

/// The default initializers are automatically available for structs.
/// - Note:  Be aware when using custom parameter strings :  `mimeType` should be valid for `fileName`
struct FormFileDataInfo {
    let data:Data
    var fieldName:String = "photo"
    var mimeType:String = "image/jpg"
    var fileName:String = "image.jpg"
}
