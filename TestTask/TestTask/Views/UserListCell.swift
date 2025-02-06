//
//  UserListCell.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

struct UserListCell: View {
    let user:UserInfo
    
    var body: some View {
        HStack {
                
            if let image = user.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height:50)
            }
            else {
                Circle()
                    .fill(Color.secondaryInactive)
                    .frame(width: 50, height: 50)
            }
        }
    }
}

#Preview {
    UserListCell(user: UserInfo.fromUser(User.dummies[0]))
}
