//
//  TabBarContainer.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

struct TabBarContainer<Content>: View where Content:View {
    let content:Content
    @Binding var selection:TabItem
    
    @State private var tabItems:[TabItem] = []
    
    init(selection:Binding<TabItem>, @ViewBuilder content contentFunc: @escaping () -> Content ) {
        self._selection = selection
        self.content = contentFunc()
    }
    var body: some View {
        VStack(spacing:0) {
            ZStack {
                content
            }
            TabBar(tabItems: tabItems, selection: $selection)
        }
        .onPreferenceChange(SelectedTabPreferenceKey.self, perform: { newValue in
            self.tabItems = newValue
        })
    }
}


#Preview {
    
    TabBarContainer(selection: .constant(.signup), content: {
        UsersListView(viewModel: UsersListViewModel(loader: UsersLoader(), pageItemsCount: 6))
            .customTabBarItem(.users, selection: .constant(.users))
        
        SignupView()
            .customTabBarItem(.signup, selection: .constant(.signup))
    })
}
