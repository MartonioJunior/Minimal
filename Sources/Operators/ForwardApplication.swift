//
//  ForwardApplication.swift
//  
//
//  Created by Martônio Júnior on 24/01/24.
//

import Functional

// MARK: Precedence Group
precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

// MARK: Forward Pipe (|>)
infix operator |>: ForwardApplication
/// Applies a value to a given closure.
/// - Parameters:
///   - lhs: Value to apply.
///   - rhs: Closure to execute.
///
/// - Throws: `E` when an error happens while running `rhs`.
/// - Returns: Output of the `rhs` function.
public func |> <A, B, E: Error>(
    lhs: A,
    rhs: @escaping (A) throws(E) -> B
) throws(E) -> B {
    try rhs(lhs)
}

// MARK: Purify (<|)
infix operator <|: ForwardApplication
postfix operator <|
/// Purifies a mutating function.
/// - Parameter lhs: Mutating function.
/// - Returns: Pure function.
public postfix func <| <A, E: Error>(
    lhs: @escaping (inout A) throws(E) -> Void
) -> (A) throws(E) -> A {
    purify(lhs)
}
/// Purifies a mutating function.
/// - Parameter lhs: Mutating function.
/// - Returns: Pure function.
public postfix func <| <A, each B, E: Error>(
    lhs: @escaping (inout A) throws(E) -> (repeat each B)
) -> (A) throws(E) -> (A, repeat each B) {
    purify(lhs)
}
/// Applies a mutating function to a pure value.
/// - Parameters:
///   - lhs: Mutating function.
///   - rhs: Pure value.
///
/// - Throws: `E` when the mutating function throws.
/// - Returns: Value after the mutation.
public func <| <A, E: Error>(
    lhs: @escaping (inout A) throws(E) -> Void,
    rhs: A
) throws(E) -> A {
    try purify(lhs)(rhs)
}
/// Applies a mutating function to a pure value.
/// - Parameters:
///   - lhs: Mutating function.
///   - rhs: Pure value.
/// - Returns: Pure function.
/// 
/// - Throws: `E` when the mutating function throws.
/// - Returns: Value after the mutation and it's function outputs.
public func <| <A, each B, E: Error>(
    lhs: @escaping (inout A) throws(E) -> (repeat each B),
    rhs: A
) throws(E) -> (A, repeat each B) {
    try purify(lhs)(rhs)
}

// MARK: Forward Mutation (&>)
infix operator &>: ForwardApplication
/// Mutates a value type with a closure.
/// - Parameters:
///   - lhs: Value to be mutated.
///   - rhs: Mutation closure.
///
/// - Throws: `E` when an error happens while running `rhs`.
/// - Returns: Mutated value.
@_disfavoredOverload
public func &> <A, E: Error>(
    lhs: A,
    rhs: @escaping (inout A) throws(E) -> Void
) throws(E) -> A {
    var lhs = lhs
    try rhs(&lhs)
    return lhs
}
/// Mutates a reference type with a closure.
/// - Parameters:
///   - lhs: Reference to be mutated.
///   - rhs: Mutation closure.
///
/// - Throws: `E` when an error happens while running `rhs`.
/// - Returns: Mutated reference.
@discardableResult
public func &> <A: AnyObject, E: Error>(
    lhs: A,
    rhs: @escaping (A) throws(E) -> Void
) throws(E) -> A {
    try rhs(lhs)
    return lhs
}

// MARK: Mutating (<&)
infix operator <&: ForwardApplication
postfix operator <&
/// Transforms a pure function into a mutating one.
/// - Parameter lhs: Pure function.
/// - Returns: Mutating function.
public postfix func <& <A, E: Error>(
    lhs: @escaping (A) throws(E) -> A
) -> (inout A) throws(E) -> Void {
    mutating(lhs)
}
/// Transforms a pure function into a mutating one.
/// - Parameter lhs: Pure function.
/// - Returns: Mutating function.
public postfix func <& <A, B, E: Error>(
    lhs: @escaping (A) throws(E) -> (A, B)
) -> (inout A) throws(E) -> B {
    mutating(lhs)
}
/// Mutates a value with a pure transformation.
/// - Parameters:
///   - lhs: Pure function.
///   - rhs: Mutation reference.
///
/// - Throws: `E` when the pure function throws.
public func <& <A, E: Error>(
    lhs: @escaping (A) throws(E) -> A,
    rhs: inout A
) throws(E) {
    try mutating(lhs)(&rhs)
}
/// Mutates a value with a pure transformation.
/// - Parameters:
///   - lhs: Pure function.
///   - rhs: Mutation reference.
///
/// - Throws: `E` when the pure function throws.
/// - Returns: Extra outputs of the pure function
public func <& <A, B, E: Error>(
    lhs: @escaping (A) throws(E) -> (A, B),
    rhs: inout A
) throws(E) -> B {
    try mutating(lhs)(&rhs)
}

// MARK: Swap (<&>)
infix operator <&>: ForwardApplication
/// Swaps two variables around.
/// - Parameters:
///   - lhs: A variable.
///   - rhs: Another variable.
///
public func <&> <A>(
    _ lhs: inout A,
    _ rhs: inout A
) {
    swap(&lhs, &rhs)
}

// MARK: Optionalize (<?)
postfix operator <?
/// Transforms a function to work with optionals
/// - Parameter lhs: Function with non-optional inputs and outputs.
/// - Returns: Function with optional inputs and outputs.
public postfix func <? <each A, B, E: Error>(
    lhs: @escaping (repeat each A) throws(E) -> B
) -> (repeat Optional<each A>) throws(E) -> B? {
    { (args: repeat Optional<each A>) in
        var elements = [Any]()

        for element in repeat each args {
            guard let element else { return nil }

            elements.append(element)
        }

        var iterator = elements.makeIterator()
        guard let t = try? (repeat { t in try cast(iterator.next(), as: t) }((each A).self)) else { return nil }
        return try? lhs(repeat each t)

        func cast<Value, T>(_ value: Value, as _: T.Type) throws(CancellationError) -> T {
            guard case let cast as T = value else { throw .init() }

            return cast
        }
    }
}
