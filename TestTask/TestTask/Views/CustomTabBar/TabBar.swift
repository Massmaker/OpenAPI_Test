//
//  TabBar.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI


struct TabBar: View {
    let tabItems:[TabItem]
    @Binding var selection:TabItem
    
    var body: some View {
        HStack {
            ForEach(tabItems, content: { tabItem in
                
                TabItemView(item:tabItem, isSelected: selection == tabItem)
                    .onTapGesture(perform: {
                        selection = tabItem
                    })
            })
        }
        .frame(height:56)
        .background {
            Color.barBackground
        }
    }
}

#Preview {
    TabBar(tabItems: [TabItem.users, .signup], selection: .constant(.users))
}
