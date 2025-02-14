//
//  UserSignupResult.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

struct UserSignupResult : Identifiable {
    let success:Bool
    let message:String
    let action:(title:String, work: ()->() )
    
    let id:UUID = UUID()
}
