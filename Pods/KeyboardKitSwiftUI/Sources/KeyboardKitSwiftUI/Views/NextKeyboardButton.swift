//
//  NextKeyboardButton.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-03-11.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI
import KeyboardKit

/**
 This button switches to the next system keyboard when it is
 tapped and opens a system keyboard menu when it is pressed.
 */
public struct NextKeyboardButton: UIViewRepresentable {
    
    public init(
        controller: KeyboardInputViewController,
        tintColor: UIColor = .label,
        pointSize: CGFloat = 25,
        weight: UIImage.SymbolWeight = .light,
        scale: UIImage.SymbolScale = .medium) {
        self.button = NextKeyboardUIButton(
            controller: controller,
            tintColor: tintColor,
            pointSize: pointSize,
            weight: weight,
            scale: scale)
    }
    
    private let button: UIButton
    
    public func makeUIView(context: Context) -> UIButton { button }

    public func updateUIView(_ uiView: UIButton, context: Context) {}
}
