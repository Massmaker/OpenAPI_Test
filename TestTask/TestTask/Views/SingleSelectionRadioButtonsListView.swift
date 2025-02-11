//
//  SIngleSelectionRadioButtonsListView.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import SwiftUI

protocol SelectableItem:Identifiable {
    var title:String{get}
}

struct SingleSelectionRadioButtonsListView<Item:SelectableItem>: View {
    
    let header:String
    let items:[Item]
    @Binding var selection:Item?
    var animateSelection:Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Text(header)
                .body2TextStyle()
            
            LazyVStack(alignment: .leading, spacing: 16, content: {
                ForEach(items, content: {item in
                    RadioButtonListCell(title: item.title,
                                        isSelected: selection?.title == item.title)
                        .onTapGesture {
                            if animateSelection {
                                withAnimation {
                                    selection = item
                                }
                            }
                            else {
                                selection = item
                            }
                        }
                })
            })
            .padding(.horizontal)
        })
    }
}

#Preview {
    SingleSelectionRadioButtonsListView<String>(header: "Select desired position", items: ["Frontend developer", "Backend developer", "Android developer", "iOS developer", "QA"], selection: .constant("Backend developer"))
}


extension String: @retroactive Identifiable {
    public var id:String { self }
}

extension String:SelectableItem {
    var title:String { self }
    
}
