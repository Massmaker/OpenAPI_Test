//
//  UserUIInfo.swift
//  TestTask
//
//  Created by Ivan_Tests on 10.02.2025.
//

import Foundation
import UIKit
/// Data struct to display User info in the lists
struct UserUIInfo {
    let user:User
    var profileImage:UIImage?
}


extension UserUIInfo : Identifiable {
    var id: UserId {
        user.id
    }
}

extension UserUIInfo {
    var registrationTimestamp:TimeInterval {
        user.registrationTimestamp ?? 0
    }

    var name:String {
        user.name
    }
    
    var phone:String {
        user.phone
    }
    
    var position:String {
        user.position
    }
    
    var email:String {
        user.email
    }
}

extension UserUIInfo {
    static var dummies:[UserUIInfo] = [UserUIInfo(user: User.dummies[0]), UserUIInfo(user: User.dummies[1], profileImage: UIImage(named:"Image_profile1")), UserUIInfo(user: User.dummies[2])]
}
