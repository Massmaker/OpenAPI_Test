//
//  PermissionsHandling.swift
//  TestTask
//
//  Created by Ivan_Tests on 12.02.2025.
//

import Foundation
import UIKit
import AVFoundation
import UIKit

protocol CameraAccessPermissionsHandling {
    func checkCameraAccessPermissions() async throws
}

enum CameraAccessError:Error {
    enum AuthorizationStatusError {
        case denied, restricted
    }
    case permissionError(AuthorizationStatusError)
    case unsupported
}

final class CameraUsagePermissionsHandler:CameraAccessPermissionsHandling {
    
    func checkCameraAccessPermissions() async throws (CameraAccessError) {
        
        #if targetEnvironment(simulator)
        throw CameraAccessError.unsupported
        #endif
        
        let isFrontCameraAvailable =  await UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front)
        
        let isRearCameraAvailable = await UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear)
        
        guard isRearCameraAvailable || isFrontCameraAvailable else {
            throw CameraAccessError.unsupported
        }
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status {
        case .notDetermined:
            let allowed = await AVCaptureDevice.requestAccess(for: .video)
            if !allowed {
                throw .permissionError(.denied)
            }
        case .restricted:
            throw .permissionError(.restricted)
        case .denied:
            throw .permissionError(.denied)
        case .authorized:
            return
        @unknown default:
            fatalError("Unhandled Camera_Access Authorization status")
        }
        
        
    }
}


struct CameraAccessPermissionsDummy:CameraAccessPermissionsHandling {
    func checkCameraAccessPermissions() async throws {
        throw CameraAccessError.unsupported
    }
}
