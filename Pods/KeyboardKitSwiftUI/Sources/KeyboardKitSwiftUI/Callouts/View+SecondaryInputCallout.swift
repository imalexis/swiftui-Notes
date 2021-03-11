//
//  View+SecondaryInputCallout.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-06.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import SwiftUI

public extension View {
    
    /**
     This modifier can be applied to any view that should be
     able to present a secondary input callout.
     */
    func secondaryInputCallout(
        for keyboardContext: KeyboardContext,
        context: SecondaryInputCalloutContext = .shared,
        style: SecondaryInputCalloutStyle = .standard) -> some View {
        return ZStack {
            self
            SecondaryInputCallout(context: context, style: style)
        }.coordinateSpace(name: SecondaryInputCalloutContext.coordinateSpace)
    }
}
