//
//  AlertInfo.swift
//  TestTask
//
//  Created by Ivan_Tests on 12.02.2025.
//

import Foundation

struct AlertInfo {
    let title:String
    let message:String?
    let actions:[AlertAction]
}

struct AlertAction: Identifiable {
    let title:String
    let emphasized:Bool
    let destructive:Bool
    let work: () -> ()
    
    //Identifiable
    let id:String = UUID().uuidString
}

extension AlertAction {
    
    static func regular(with title:String, work:@escaping()->()) -> AlertAction {
        AlertAction(title: title, emphasized: false, destructive: false, work: work)
    }
    
    static func emphasizedNonDestructive(with title:String, work:@escaping ()->()) -> AlertAction {
        AlertAction(title: title, emphasized: true, destructive: false, work: work)
    }
    
    static func nonEmphasizedDestructive(with title:String, work: @escaping ()->()) -> AlertAction {
        AlertAction(title: title, emphasized: false, destructive: true, work: work)
    }
    
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
