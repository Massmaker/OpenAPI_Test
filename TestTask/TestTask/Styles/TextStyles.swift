//
//  TextViewExtensions.swift
//  TestTask
//
//  Created by Ivan_Tests on 10.02.2025.
//

import Foundation
import SwiftUI






struct TextBodyModifier:ViewModifier {
    let font:UIFont
    var lineHeight:CGFloat = 0
    let secondary:Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        if lineHeight > 0 {
            content
                .font(Font(font))
                .lineSpacing(lineHeight - font.lineHeight)
                .padding(.vertical, (lineHeight - font.lineHeight) / 2)
                .foregroundStyle(secondary ? Color.secondaryInactive : textColor)
        }
        else {
            content
                .font(Font(font))
                .foregroundStyle(secondary ? Color.secondaryInactive : textColor)
        }
    }
    
    private var textColor:Color {
        if case .light = colorScheme {
            Color.black
        }
        else {
            Color.white
        }
    }
}

extension View {
    func heading1TextStyle() -> some View {
        modifier(TextBodyModifier(font: .mainFont(size: 20), lineHeight: 24, secondary: false))
    }
    
    func body1TextStyle(secondary:Bool = false) -> some View {
        modifier(TextBodyModifier(font: .mainFont(size: 16), lineHeight: 24, secondary: secondary))
    }
    
    func body2TextStyle(secondary:Bool = false) -> some View {
        modifier(TextBodyModifier(font: .mainFont(size: 18), lineHeight: 24, secondary: secondary))
    }
    
    func body3TextStyle(secondary:Bool = false) -> some View {
        modifier(TextBodyModifier(font: .mainFont(size: 18), lineHeight:20, secondary: secondary))
    }
}
