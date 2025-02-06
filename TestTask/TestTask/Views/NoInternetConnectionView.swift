//
//  NoInternetConnectionView.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

struct NoInternetConnectionView: View {
    
    let tryAgainAction:()->()
    
    var body: some View {
        VStack {
            Image("No_Connection")
            
            Text("There is no internet connection")
                .font(Font(UIFont(name: "NunitoSans-Regular", size: 20)!))
                .padding()
            
            Button("Try again", action: tryAgainAction )
            .buttonStyle( .primaryButtonStyle)
    
        }
        .background(Color.white)
    }
}

#Preview {
    NoInternetConnectionView(tryAgainAction: {})
}
