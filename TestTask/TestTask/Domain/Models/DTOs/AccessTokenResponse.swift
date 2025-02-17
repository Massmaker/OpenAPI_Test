//
//  AccessTokenResponse.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

struct AccessTokenResponse:Decodable {
    let success:Bool
    let token:AccessToken
}
