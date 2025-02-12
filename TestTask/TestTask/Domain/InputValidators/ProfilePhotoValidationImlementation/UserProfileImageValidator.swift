//
//  UserProfileImageValidator.swift
//  TestTask
//
//  Created by Ivan_Tests on 12.02.2025.
//

import Foundation
import UIKit

let kImageDataSizeMaxValue:Int = 5_242_880 //5MegaBytes
class UserProfileImageValidator: ProfileImageValidating {
    
    func validate(_ jpegImageData: Data) -> Bool {
            
        // filesize should be less than 5 MB
        guard jpegImageData.count >= kImageDataSizeMaxValue else {
            return false
        }

        // photo has to have at least 70x70 px
        guard let jpegImage = UIImage(data: jpegImageData) else {
            return false
        }
        
        let imageSize = jpegImage.size
        
        guard imageSize.height >= 70, imageSize.width >= 70 else {
            return false
        }
        
        return true
    }
}
