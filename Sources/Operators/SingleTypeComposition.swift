//
//  SingleTypeComposition.swift
//
//
//  Created by Martônio Júnior on 24/01/24.
//

import Overture

// MARK: Precedence Group
precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

// MARK: Concat (<>)
infix operator <>: SingleTypeComposition
/// Composes multiple mutating functions into one.
/// - Parameters:
///   - lhs: A mutating function.
///   - rhs: Another mutating function.
///
/// - Returns: Mutating function that combones both functions.
public func <> <A, E: Error>(
    lhs: @escaping (inout A) throws(E) -> Void,
    rhs: @escaping (inout A) throws(E) -> Void
) -> (inout A) throws(E) -> Void {
    {
        try lhs(&$0)
        try rhs(&$0)
    }
}
/// Composes multiple mutating functions into one.
/// - Parameters:
///   - lhs: A mutating function.
///   - rhs: Another mutating function.
///
/// - Returns: Mutating function that combones both functions.
public func <> <A: AnyObject, E: Error>(
    lhs: @escaping (A) throws(E) -> Void,
    rhs: @escaping (A) throws(E) -> Void
) -> (A) throws(E) -> Void {
    {
        try lhs($0)
        try rhs($0)
    }
}
