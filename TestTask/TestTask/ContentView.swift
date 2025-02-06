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
            UsersListView(viewModel: rootModel.usersListViewModel)
                .customTabBarItem(.users, selection: $selectedTab)
            
            SignupView()
                .customTabBarItem(.signup, selection: $selectedTab)
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
