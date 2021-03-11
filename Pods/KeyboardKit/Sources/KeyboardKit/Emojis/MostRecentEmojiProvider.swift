//
//  MostRecentEmojiProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-16.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This emoji provider can be used to return the most recently
 used emojis.
 
 This class implements `FrequentEmojiProvider` but is simple
 compared to a real "frequent" provider, which should keep a
 list of recent and still relevant emojis, remember the user
 tap count etc.
*/
public class MostRecentEmojiProvider: FrequentEmojiProvider {
    
    public init(
        maxCount: Int = 30,
        defaults: UserDefaults = .standard) {
        self.maxCount = maxCount
        self.defaults = defaults
    }
    
    private let defaults: UserDefaults
    private let maxCount: Int
    private let key = "com.keyboardkit.MostRecentEmojiProvider.emojis"
    
    public var emojis: [String] {
        defaults.stringArray(forKey: key) ?? []
    }
    
    public func registerEmoji(_ emoji: String) {
        var emojis = self.emojis.filter { $0 != emoji }
        emojis.insert(emoji, at: 0)
        let result = Array(emojis.prefix(maxCount))
        defaults.set(result, forKey: key)
    }
}
