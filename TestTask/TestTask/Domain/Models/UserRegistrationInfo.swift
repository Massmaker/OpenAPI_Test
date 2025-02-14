//
//  UserRegistrationInfo.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import Foundation


struct UserRegistrationRequestInfo {
    
    let name:String
    let email:String
    let phone:String
    let positionId:Int
    let photo:Data
}


struct UserRegistrationResponse:Decodable {
    let success:Bool
    let userId: UserId //Int
    var message:String?
}

extension UserRegistrationRequestInfo: MultipartFormDataEncodable {
    var formFields: [String : String] {
        return ["name":name, "email":email, "phone":phone, "position_id":"\(positionId)"]
    }
    
    var fileDataInfo: FormFileDataInfo {
        FormFileDataInfo(data: photo)
    }
}


protocol MultipartFormDataEncodable {
    var formFields:[String:String] {get}
    var fileDataInfo:FormFileDataInfo {get}
}

/// the default initializers are automatically available for structs. Be aware when using custop parameter strings :  `mimeType` should be valid for `fileName`
struct FormFileDataInfo {
    let data:Data
    var fieldName:String = "photo"
    var mimeType:String = "image/jpg"
    var fileName:String = "image.jpg"
}
