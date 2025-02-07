//
//  UserListCell.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

struct UserListCell: View {
    let user:User
    
    var body: some View {
        HStack {
                
            let url = user.imageURL()
            
            AsyncImage(url: url,
                       content: { image in
                image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
            },
                       placeholder: {
                Circle()
                    .fill(Color.secondaryInactive)
                    .frame(width: 50, height: 50)
            })
            .id(user.id)
            
            VStack(alignment: .leading, spacing: 20) {
                Text(user.name)
                
                Text(user.position)
                    .foregroundStyle(.secondary)
                
                Text(user.email)
                
                Text(user.phone)
                
            }
        }
    }
}

#Preview {
    UserListCell(user: User.dummies[0])
}
