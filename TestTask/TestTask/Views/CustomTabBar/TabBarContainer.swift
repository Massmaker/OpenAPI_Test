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
        UsersListView(viewModel: UsersListViewModel(loader: UsersLoader(),
                                                    pageItemsCount: 6,
                                                    profilePhotoCache: ImageCache.shared))
            .customTabBarItem(.users, selection: .constant(.users))
        
        SignupView(viewModel: SignupViewModel(userPositionsLoader: UserPositionsLoader(session: URLSession(configuration: .ephemeral) ),
                                              cameraAccessHandler: CameraAccessPermissionsDummy(),
                                              userRegistrator: UserRegistrationDummy(succeeding:true)))
            .customTabBarItem(.signup, selection: .constant(.signup))
    })
}
