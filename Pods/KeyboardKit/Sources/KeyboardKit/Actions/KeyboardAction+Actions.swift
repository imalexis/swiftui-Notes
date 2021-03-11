//
//  KeyboardAction+Actions.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-07-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import UIKit

/**
 This extension defines various standard actions for various
 `KeyboardAction` types.
 
 To customize which actions that are actually performed when
 a user triggers a keyboard action, inject a custom keyboard
 action handler into your keyboard.
 */
public extension KeyboardAction {
    
    
    // MARK: - Types
    
    typealias GestureAction = (KeyboardInputViewController?) -> Void
    typealias InputViewControllerAction = (KeyboardInputViewController?) -> Void
    typealias TextDocumentProxyAction = (UITextDocumentProxy?) -> Void
    
    /**
     The standard action, if any, that should be executed on
     an input view controller, when this action is triggered
     with a long press.
     */
    var standardLongPressAction: GestureAction? {
        switch self {
        case .backspace: return standardTapAction
        default: return nil
        }
    }
    
    /**
     The standard action, if any, that should be executed on
     an input view controller, when this action is triggered
     with a press and hold.
     */
    var standardRepeatAction: GestureAction? {
        switch self {
        case .backspace: return standardTapAction
        default: return nil
        }
    }
    
    /**
     The standard action, if any, that should be executed on
     an input view controller or a text document proxy, when
     this action is triggered with a tap.
     */
    var standardTapAction: GestureAction? {
        if let action = standardTapActionForController { return action }
        if let action = standardTapActionForProxy { return { action($0?.textDocumentProxy) } }
        return nil
    }
    
    /**
     The standard action, if any, that should be executed on
     an input view controller, when this action is triggered
     with a tap.
     */
    var standardTapActionForController: InputViewControllerAction? {
        switch self {
        case .dismissKeyboard: return { $0?.dismissKeyboard() }
        case .emojiCategory(let cat): return { $0?.context.emojiCategory = cat }
        case .keyboardType(let type): return { $0?.changeKeyboardType(to: type) }
        case .shift(let currentState): return {
            switch currentState {
            case .lowercased: $0?.changeKeyboardType(to: .alphabetic(.uppercased))
            case .uppercased: $0?.changeKeyboardType(to: .alphabetic(.lowercased))
            case .capsLocked: $0?.changeKeyboardType(to: .alphabetic(.lowercased))
            }}
        default: return nil
        }
    }
    
    /**
     The standard action, if any, that should be executed on
     a text document proxy when the action is triggered with
     a tap.
     */
    var standardTapActionForProxy: TextDocumentProxyAction? {
        switch self {
        case .backspace: return { $0?.deleteBackward() }
        case .character(let char): return { $0?.insertText(char) }
        case .emoji(let char): return { $0?.insertText(char) }
        case .moveCursorBackward: return { $0?.adjustTextPosition(byCharacterOffset: -1) }
        case .moveCursorForward: return { $0?.adjustTextPosition(byCharacterOffset: 1) }
        case .newLine: return { $0?.insertText("\n") }
        case .space: return { $0?.insertText(" ") }
        case .tab: return { $0?.insertText("\t") }
        default: return nil
        }
    }
}
