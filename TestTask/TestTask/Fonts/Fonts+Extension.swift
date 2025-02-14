//
//  Fonts+Extension.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation
extension String {
    static var regularFontName:String { "NunitoSans-Regular" }
}


import SwiftUI

extension Font {
    static let regularButton:Font = Font(UIFont(name: "NunitoSans-Regular", size: 18)!)
    static let regularText:Font = Font(UIFont(name: "NunitoSans-Regular", size: 20)!)
    static let subtitleTextFont:Font = Font(UIFont(name: .regularFontName, size: 14)!)
}


import UIKit

extension UIFont {
    static func mainFont(size:CGFloat) -> UIFont {
        UIFont(name: .regularFontName, size: size)! //if this breaks, early project adjustments should be made.
    }

}
