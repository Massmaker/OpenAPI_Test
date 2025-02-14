//
//  UsersListView.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

struct UsersListView: View {
    
    @ObservedObject var viewModel:UsersListViewModel<UsersLoader,ImageCache>
    
    var body: some View {
        VStack(spacing:0) {
            HeaderView(title: "Working wit GET request")
            
            if viewModel.users.isEmpty && !viewModel.isLoading {
                EmptyUsersListView()
            }
            else {
                List(viewModel.users) { userInfo in
                    UserListCell(user:userInfo, avatarImage: userInfo.profileImage)
                            .id(userInfo.id)
                            .onAppear{ viewModel.onUserAppear(userInfo.id) // scrolling to bottom of the list detection}
                    }
                }
                .listStyle(.plain)
            }
            
        }
        .overlay(alignment: .bottom, content: {
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                    Spacer()
                }
                .padding(.vertical)
            }
        })
        .onAppear{
            viewModel.onViewAppear()
        }
    }
}

#Preview {
    UsersListView(viewModel: UsersListViewModel(loader: UsersLoader(), pageItemsCount: 6, profilePhotoCache: ImageCache.shared))
}
