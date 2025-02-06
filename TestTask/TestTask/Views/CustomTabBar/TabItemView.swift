//
//  TabItemView.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

struct TabItemView: View {
    let item:TabItem
    let isSelected:Bool
    
    var body: some View {
        HStack {
            Image(item.imageName)
            Text(item.title)
        }
        .foregroundStyle(isSelected ? Color.secondaryColor : Color.secondaryInactive)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TabItemView(item: .users, isSelected: true)
}
