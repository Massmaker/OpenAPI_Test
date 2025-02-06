//
//  HeaderView.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import SwiftUI

struct HeaderView: View {
    let title:String
    var body: some View {
        HStack {
            Text(title)
                .padding()
        }
        .frame(height:56)
        .frame(maxWidth:.infinity)
        .background(Color.primaryColor)
    }
}

#Preview {
    HeaderView(title: "Working with GET request")
}
