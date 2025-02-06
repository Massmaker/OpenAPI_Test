//
//  UsersListView.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

struct UsersListView: View {
    
    @ObservedObject var viewModel:UsersListViewModel
    
    var body: some View {
        VStack {
            HeaderView(title: "Working wit GET request")
            
            if viewModel.users.isEmpty {
                
            }
            else {
                List(viewModel.users) { user in
                    UserListCell(user:user)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    UsersListView(viewModel: UsersListViewModel())
}
