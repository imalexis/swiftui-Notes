//
//  UIColor+Copy.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2018-02-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import UIKit

public extension UIImage {
    
    /**
     Copies the image as png to the pasteboard.
     */
    func copyToPasteboard(_ pasteboard: UIPasteboard = .general) -> Bool {
        guard let data = pngData() else { return false }
        pasteboard.setData(data, forPasteboardType: "public.png")
        return true
    }
}
