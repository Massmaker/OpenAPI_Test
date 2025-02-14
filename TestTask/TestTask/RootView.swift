//
//  ContentView.swift
//  Test Task
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var networkAvailabilityMonitor:NetworkStatusWorker = .init()
    @State var selectedTab:TabItem = .users

    @ObservedObject var rootModel:RootModel
    
    var body: some View {
        TabBarContainer(selection: $selectedTab, content: {
            
            if selectedTab == .users {
                UsersListView(viewModel: rootModel.usersListViewModel)
                    .customTabBarItem(.users, selection: $selectedTab)
                
            }
            else {
                Color.secondaryDarkColor
                    .customTabBarItem(.users, selection: $selectedTab)
            }
            
            if selectedTab == .signup {
                SignupView(viewModel: rootModel.userSignupViewModel)
                    .customTabBarItem(.signup, selection: $selectedTab)
            }
            else {
                Color.secondary
                    .customTabBarItem(.signup, selection: $selectedTab)
            }
        })
        .overlay {
            if !networkAvailabilityMonitor.isConnected {
                
                NoInternetConnectionView(tryAgainAction: {
                    fatalError("Try Again Not implemented for No Internet Connection action")
                })
            }
        }
    }
}

#Preview {
    RootView(rootModel: RootModel())
}
