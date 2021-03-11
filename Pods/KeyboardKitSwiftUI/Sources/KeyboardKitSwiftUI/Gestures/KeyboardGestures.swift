//
//  KeyboardGestures.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-10.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import SwiftUI

/**
 This view wraps a view then applies keyboard gestures to it.
 It can be applied with the `keyboardGestures` view modifier.
 */
struct KeyboardGestures<Content: View>: View {
    
    init(
        view: Content,
        action: KeyboardAction?,
        tapAction: KeyboardGestureAction?,
        doubleTapAction: KeyboardGestureAction?,
        longPressAction: KeyboardGestureAction?,
        repeatAction: KeyboardGestureAction?,
        dragAction: KeyboardDragGestureAction?,
        inputCalloutContext: InputCalloutContext,
        secondaryInputCalloutContext: SecondaryInputCalloutContext) {
        self.view = view
        self.action = action
        self.tapAction = tapAction
        self.doubleTapAction = doubleTapAction
        self.longPressAction = longPressAction
        self.repeatAction = repeatAction
        self.dragAction = dragAction
        self.inputCalloutContext = inputCalloutContext
        self.secondaryInputCalloutContext = secondaryInputCalloutContext
    }
    
    private let view: Content
    private let action: KeyboardAction?
    private let tapAction: KeyboardGestureAction?
    private let doubleTapAction: KeyboardGestureAction?
    private let longPressAction: KeyboardGestureAction?
    private let repeatAction: KeyboardGestureAction?
    private let dragAction: KeyboardDragGestureAction?
    
    private let inputCalloutContext: InputCalloutContext
    private let secondaryInputCalloutContext: SecondaryInputCalloutContext
    
    @State private var isRepeatPressActive = false
    @State private var isInputCalloutEnabled = true
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        view.overlay(GeometryReader { geo in
            Color.clearInteractable
                .onReceive(timer) { _ in self.handleRepeatPress() }
                .gesture(tapGesture)
                .simultaneousGesture(doubleTapGesture)
                .simultaneousGesture(dragGesture(for: geo))
                .simultaneousGesture(longPressGesture)
                .simultaneousGesture(longPressDragGesture(for: geo))
        })
    }
}


// MARK: - Gestures

private extension KeyboardGestures {
    
    /**
     This is a plain double-tap gesure.
     */
    var doubleTapGesture: some Gesture {
        TapGesture(count: 2).onEnded {
            doubleTapAction?()
        }
    }
    
    /**
     This is a drag gesture that starts immediately.
     */
    func dragGesture(for geo: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                guard isInputCalloutEnabled else { return }
                inputCalloutContext.updateInput(for: action, geo: geo) }
            .onEnded { _ in
                inputCalloutContext.reset()
                isRepeatPressActive = false }
    }
    
    /**
     This is a plain long press gesure.
     */
    var longPressGesture: some Gesture {
        LongPressGesture().onEnded { _ in
            self.longPressAction?()
            self.isRepeatPressActive = true }
    }
    
    /**
     This is a drag gesture that starts after a long press.
     */
    func longPressDragGesture(for geo: GeometryProxy) -> some Gesture {
        LongPressGesture()
            .onEnded { _ in beginSecondaryInputGesture(for: geo) }
            .sequenced(before: DragGesture(minimumDistance: 0))
            .onChanged {
                switch $0 {
                case .first: break
                case .second(_, let drag): handleSecondaryInputDragGesture(drag)
                }
            }
            .onEnded { _ in endSecondaryInputGesture() }
    }
    
    /**
     This is a plain tap gesure.
     */
    var tapGesture: some Gesture {
        TapGesture().onEnded {
            tapAction?()
            inputCalloutContext.reset()
        }
    }
}


// MARK: - Functions

private extension KeyboardGestures {
    
    func beginSecondaryInputGesture(for geo: GeometryProxy) {
        isInputCalloutEnabled = false
        secondaryInputCalloutContext.updateInputs(for: action, geo: geo)
        guard secondaryInputCalloutContext.isActive else { return }
        inputCalloutContext.reset()
    }
    
    func endSecondaryInputGesture() {
        isInputCalloutEnabled = true
        let shouldTap = !secondaryInputCalloutContext.isActive
        if shouldTap { tapAction?() }
        secondaryInputCalloutContext.endDragGesture()
        guard secondaryInputCalloutContext.isActive else { return }
    }
    
    func handleSecondaryInputDragGesture(_ drag: DragGesture.Value?) {
        secondaryInputCalloutContext.updateSelection(with: drag)
        guard let drag = drag else { return }
        dragAction?(drag.startLocation, drag.location)
    }
    
    func handleRepeatPress() {
        guard isRepeatPressActive else { return }
        repeatAction?()
    }
}
