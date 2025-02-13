//
//  EmptyUsersListView.swift
//  TestTask
//
//  Created by Ivan_Tests on 07.02.2025.
//

import SwiftUI

struct EmptyUsersListView: View {
    var body: some View {
        VStack (spacing: 20){
            Image("state_empty")
                
            Text("There are no users yet")
                .font(.regularText)
        }
    }
}

#Preview {
    EmptyUsersListView()
}
