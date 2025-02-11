//
//  RadioButtonListCell.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import SwiftUI

struct RadioButtonListCell: View {
    let title:String
    var isSelected:Bool
    
    var body: some View {
        
        HStack {
            stateCircle
                .frame(width:14, height:14)
            Text(title)
                .body1TextStyle()
        }
    }
    
    @ViewBuilder private var stateCircle: some View {
        if isSelected {
            
            Color.secondaryColor
                .clipShape(Circle())
                .overlay{
                    Circle()
                        .fill(Color.white)
                        .frame(width:6, height:6)
                    
                }
            
        }
        else {
            Circle()
                .fill(Color.disabledItemBorder)
                .overlay{
                    Color.white
                        .frame(width:13, height:13)
                        .clipShape(Circle())
                }
            
        }
    }
}

#Preview {
    VStack {
        RadioButtonListCell(title: "FrontEnd developer", isSelected: false)
        RadioButtonListCell(title: "FrontEnd developer", isSelected: true)
    }
}
