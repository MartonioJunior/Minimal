//
//  Prototype.swift
//
//
//  Created by Martônio Júnior on 23/09/23.
//

import Foundation
import Overture

/// Modifier that creates new instances of a type
public struct Prototype<Value> {
    var clone: @Sendable (Value) -> Value
}

// MARK: Sendable
extension Prototype: Sendable where Value: Sendable {}

// MARK: Sequence
public extension Sequence {
    func map(using prototype: Prototype<Element>) -> [Element] { map { prototype.clone($0) } }
}
