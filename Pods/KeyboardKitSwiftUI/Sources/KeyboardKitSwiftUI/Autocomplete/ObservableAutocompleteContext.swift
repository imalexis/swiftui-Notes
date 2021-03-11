//
//  ObservableAutocompleteContext.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-09-12.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import Combine

public class ObservableAutocompleteContext: ObservableObject, AutocompleteContext {
    
    public init() {}
    
    @Published public var suggestions: [AutocompleteSuggestion] = []
}
