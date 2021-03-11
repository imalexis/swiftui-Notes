//
//  StandardKeyboardBehavior.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-28.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This class defines how a standard, Western keyboard behaves.
 You can subclass it and override any parts you need.
 
 This class makes heavy use of default logic in for instance
 the text document proxy. However, having this makes it easy
 to change the actual behavior, if you want or need to.
 
 `TODO` Test the threshold-based functionality.
 */
open class StandardKeyboardBehavior: KeyboardBehavior {
    
    public init(
        doubleTapThreshold: TimeInterval = 0.2,
        endSentenceThreshold: TimeInterval = 3.0) {
        self.doubleTapThreshold = doubleTapThreshold
        self.endSentenceThreshold = endSentenceThreshold
    }
    
    var lastShiftCheck = Date()
    var lastSpaceTap = Date()
    
    private let doubleTapThreshold: TimeInterval
    private let endSentenceThreshold: TimeInterval
    
    public func preferredKeyboardType(for context: KeyboardContext, after gesture: KeyboardGesture, on action: KeyboardAction) -> KeyboardType {
        if shouldSwitchToCapsLock(for: context, after: gesture, on: action) { return .alphabetic(.capsLocked) }
        switch action {
        case .shift: return context.keyboardType
        default: return context.preferredKeyboardType
        }
    }
    
    open func shouldEndSentence(for context: KeyboardContext, after gesture: KeyboardGesture, on action: KeyboardAction) -> Bool {
        guard gesture == .tap, action == .space else { return false }
        let proxy = context.textDocumentProxy
        let isNewWord = proxy.isCursorAtNewWord
        let isNewSentence = proxy.isCursorAtNewSentence
        let isClosable = (proxy.documentContextBeforeInput ?? "").hasSuffix("  ")
        let isEndingTap = Date().timeIntervalSinceReferenceDate - lastSpaceTap.timeIntervalSinceReferenceDate < endSentenceThreshold
        let shouldClose = isEndingTap && isNewWord && !isNewSentence && isClosable
        lastSpaceTap = Date()
        return shouldClose
    }
    
    open func shouldSwitchToCapsLock(for context: KeyboardContext, after gesture: KeyboardGesture, on action: KeyboardAction) -> Bool {
        guard action.isShift else { return false }
        guard context.keyboardType.isAlphabetic else { return false }
        let isDoubleTap = Date().timeIntervalSinceReferenceDate - lastShiftCheck.timeIntervalSinceReferenceDate < doubleTapThreshold
        lastShiftCheck = Date()
        return isDoubleTap
    }
    
    open func shouldSwitchToPreferredKeyboardType(for context: KeyboardContext, after gesture: KeyboardGesture, on action: KeyboardAction) -> Bool {
        switch action {
        case .shift: return true
        default: return context.keyboardType != context.preferredKeyboardType
        }
    }
    
    public func shouldSwitchToPreferredKeyboardTypeAfterTextDidChange(for context: KeyboardContext) -> Bool {
        context.keyboardType != context.preferredKeyboardType
    }
}
