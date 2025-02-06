//
//  TabItem.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation

enum TabItem:Int, Hashable, Identifiable {
    case users = 1
    case signup = 2
    
    var id:String { //Identifiable
        switch self {
        case .users:
            "TabItem_users"
        case .signup:
            "TabItem_signup"
        }
    }
}

extension TabItem {
    var imageName:String {
        switch self {
        case .users:
            return "icon_users"
        case .signup:
            return "icon_add_User"
        }
    }
}

extension TabItem {
    var title:String {
        switch self {
        case .users:
            "Users"
        case .signup:
            "Sign up"
        }
    }
}

//MARK: - PreferenceKey
import SwiftUI

struct SelectedTabPreferenceKey:PreferenceKey {
    static var defaultValue:[TabItem] = []
    static func reduce(value: inout [TabItem], nextValue:() -> [TabItem]) {
        value += nextValue()
    }
}

struct CustomTabBarItemVMod:ViewModifier {
    let tab:TabItem
    @Binding var selected:TabItem
    
    func body(content:Content) -> some View {
        content
            .opacity(selected == tab ? 1.0 : 0.0)
            .preference(key: SelectedTabPreferenceKey.self, value: [tab])
        
    }
}

extension View {
    func customTabBarItem(_ tab:TabItem, selection:Binding<TabItem>) -> some View {
        modifier(CustomTabBarItemVMod(tab: tab, selected: selection))
    }
}
