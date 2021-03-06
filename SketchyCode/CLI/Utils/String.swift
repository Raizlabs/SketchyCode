//
//  String.swift
//  SketchyCode
//
//  Created by Brian King on 5/25/17.
//  Copyright © 2017 Brian King. All rights reserved.
//

import Foundation

extension NSString {
    var objcnessShapeAndLayerRemoved: String {
        let str = (self as String).objcnessRemoved()
            .replacingOccurrences(of: "Shape", with: "", options: [.backwards], range: nil)
            .replacingOccurrences(of: "Layer", with: "", options: [.backwards], range: nil)
        return str
    }
    
    var variabled: String {
        var first = true
        let parts = components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.lengthOfBytes(using: .utf8) > 0 }

        return parts.map({
            var string = $0
            let indicies = string.characters.indices
            let firstIndex = indicies.startIndex
            let toChange = String(string.characters[firstIndex])
            string.replaceSubrange(firstIndex...firstIndex,
                                   with: first ? toChange.lowercased() : toChange.uppercased())
            first = false
            return string
        }).joined(separator: "")
    }
}

