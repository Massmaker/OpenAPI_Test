//
//  UserListCell.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

struct UserListCell: View {
    let user:UserUIInfo
    var avatarImage:UIImage?
    
    var body: some View {
        HStack (alignment: .top, spacing:36){
            VStack {
                imageView
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .foregroundStyle(.quaternary)
            }
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .heading1TextStyle()
                    .padding(.bottom, 4)
                
#if DEBUG
                Text("\(user.position) (id: \(user.id))")
                    .body3TextStyle(secondary: true)
                
                #else
                Text(user.position)
                    .body3TextStyle(secondary: true)
                
                #endif
                
                Text(user.email)
                    .body3TextStyle()
                    .padding(.top, 8)
                
                Text(user.phone)
                    .body3TextStyle()
            }
            
        }
        .padding(.vertical, 24)
        
    }
    
    private var imageView: Image {
        if let avatarImage {
            Image(uiImage: avatarImage)
        }
        else {
            Image(systemName: "questionmark.circle.fill")
        }
    }
}

#Preview {
    
    List{
        UserListCell(user: UserUIInfo.dummies[0])
        UserListCell(user: UserUIInfo.dummies[1])
        UserListCell(user: UserUIInfo.dummies[2])
    }
    .listStyle(.plain)
    
}
