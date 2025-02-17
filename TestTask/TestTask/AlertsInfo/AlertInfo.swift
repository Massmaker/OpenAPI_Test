//
//  AlertInfo.swift
//  TestTask
//
//  Created by Ivan_Tests on 12.02.2025.
//

import Foundation

/// A data struct containing information for presenting system alerts. Can be used differently, but not targeted for that.
struct AlertInfo {
    let title:String
    let message:String?
    let actions:[AlertAction]
}

/// A part of `AlertInfo` which contains information for the system alert buttons configurations
struct AlertAction: Identifiable {
    let title:String
    let emphasized:Bool
    let destructive:Bool
    let work: () -> ()
    
    //Identifiable
    let id:String = UUID().uuidString
}

extension AlertAction {
    
    /// thin(usual) text alert button
    static func regular(with title:String, work:@escaping()->()) -> AlertAction {
        AlertAction(title: title, emphasized: false, destructive: false, work: work)
    }
    
    /// thick text alert button
    static func emphasizedNonDestructive(with title:String, work:@escaping ()->()) -> AlertAction {
        AlertAction(title: title, emphasized: true, destructive: false, work: work)
    }
    
    /// thin(usual)  red text alert button
    static func nonEmphasizedDestructive(with title:String, work: @escaping ()->()) -> AlertAction {
        AlertAction(title: title, emphasized: false, destructive: true, work: work)
    }
    
    /// thick red text alert button
    static func emphasizedDestructive(with title:String, work: @escaping ()->()) -> AlertAction {
        AlertAction(title: title, emphasized: true, destructive: true, work: work)
    }
}

import UIKit
extension AlertAction {
    static var cancel:AlertAction {
        regular(with: "Cancel", work: {})
    }
    
    static var goToSettings:AlertAction {
        emphasizedNonDestructive(with: "Settings", work: {
            guard let settingsURL = URL(string:UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) else {
                return
            }
            
            UIApplication.shared.open(settingsURL)
        })
    }
}

/// `AlertAction` info can be used as usual View component to be displayed in different screens that present the system alert popups.
import SwiftUI
extension AlertAction:View {
    
    var body: some View {
        if emphasized {
            Button(action: work, label: {
                Text(title)
                    .foregroundStyle(destructive ?  Color(uiColor: .systemRed) : Color.primary)
            })
            .keyboardShortcut(.defaultAction)
        }
        else {
            Button(action: work, label: {
                Text(title)
                    .foregroundStyle(destructive ?  Color(uiColor: .systemRed) : Color.primary)
            })
        }
    }
}
