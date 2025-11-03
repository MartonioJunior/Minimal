//
//  ForwardApplication.swift
//  
//
//  Created by Martônio Júnior on 24/01/24.
//

import Foundation
import Overture

// MARK: Precedence Group
precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

// MARK: Operators
infix operator |>: ForwardApplication // Pipe-Forward
infix operator <|: ForwardApplication // Pipe-Backward
infix operator &>: ForwardApplication // Pipe-Forward (Mutable)
infix operator <&: ForwardApplication // Pipe-Backward (Mutable)
infix operator <->: ForwardApplication // Swap
// infix operator ~>: ForwardApplication // Alternative Return / Either (Deprecated on Swift 2.0, but still declared)
// infix operator <~: ForwardApplication
// TODO: Add methods for <|, <& & <~ operators

// MARK: Methods (|>)
/// closure(value())
public func |> <A, B>(
    lhs: A,
    rhs: @escaping (A) throws -> B
) rethrows -> B {
    try with(lhs, rhs)
}

// MARK: Methods (&>)
/// Configures a variable based on it's values
public func &> <A>(
    lhs: A,
    rhs: @escaping (inout A) throws -> Void
) rethrows -> A {
    var lhs = lhs
    try rhs(&lhs)
    return lhs
}

@discardableResult
public func &> <A>(
    lhs: inout A,
    rhs: @escaping (inout A) throws -> Void
) rethrows -> A {
    try rhs(&lhs)
    return lhs
}

// MARK: Methods (<->)
public func <-> <A>(
    _ lhs: inout A,
    _ rhs: inout A
) {
    swap(&lhs, &rhs)
}

// MARK: Methods (~>)
public func ~> <A, B: Error, C: Error>(
    expression: @autoclosure () throws(B) -> A,
    errorTransform: (B) -> C
) rethrows -> A {
    do {
        return try expression()
    } catch {
        throw errorTransform(error)
    }
}

public func ~> <A, B>(
    value: @autoclosure () throws -> (A?, B),
    map: (B) throws -> A
) rethrows -> A {
    let (left, right) = try value()
    return if let left { left } else { try map(right) }
}

public func ~> <A, B>(
    value: @autoclosure () throws -> (A, B?),
    map: (A) throws -> B
) rethrows -> B {
    let (left, right) = try value()
    return if let right { right } else { try map(left) }
}
