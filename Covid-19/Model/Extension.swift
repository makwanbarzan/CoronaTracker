//
//  Extension.swift
//  CoronaTracker
//
//  Created by Makwan BK on 3/17/20.
//  Copyright © 2020 Makwan BK. All rights reserved.
//

import Foundation
import UIKit

//Replace multiple words on an array of string:
public extension String {

    ///
    /// Replaces multiple occurences of strings/characters/substrings with their associated values.
    /// ````
    /// var string = "Hello World"
    /// let newString = string.replacingMultipleOccurrences(using: (of: "l", with: "1"), (of: "o", with: "0"), (of: "d", with: "d!"))
    /// print(newString) //"He110 w0r1d!"
    /// ````
    ///
    /// - Returns:
    /// String with specified parts replaced with their respective specified values.
    ///
    /// - Parameters:
    ///     - array: Variadic values that specify what is being replaced with what value in the given string
    ///
    func replacingMultipleOccurrences<T: StringProtocol, U: StringProtocol>(using array: (of: T, with: U)...) -> String {
        var str = self
        for (a, b) in array {
            str = str.replacingOccurrences(of: a, with: b)
        }
        return str
    }

}
