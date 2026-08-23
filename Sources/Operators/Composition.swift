//
//  ForwardComposition.swift
//  
//
//  Created by Martônio Júnior on 24/01/24.
//

import Functional
import Global

// MARK: Precedence Group
precedencegroup Composition {
    associativity: left
    higherThan: ForwardApplication
}

// MARK: Forward Chain / Compose (>>>)
infix operator >>>: Composition
postfix operator >>>

public func >>> <A, B, C, E: Error>(
    lhs: @escaping (A) throws(E) -> B,
    rhs: @escaping (B) throws(E) -> C
) -> (A) throws(E) -> C {
    { (a: A) in
        try rhs(lhs(a))
    }
}

public func >>> <A, B, E: Error>(
    lhs: @autoclosure @escaping () throws(E) -> A,
    rhs: @escaping (A) throws(E) -> B
) -> () throws(E) -> B {
    { try rhs(lhs()) }
}
/// Wraps a value as a function for composition.
/// - Parameter lhs: Value to be wrapped.
/// - Returns: A wrapper function.
public postfix func >>> <A>(lhs: A) -> () -> A {
    { lhs }
}
/// Curries a function.
/// - Parameter lhs: A function.
/// - Returns: Curried function.
public postfix func >>> <A, B, C, E: Error>(
    lhs: @escaping (A, B) throws(E) -> C
) -> (A) -> (B) throws(E) -> C {
    { (a: A) in
        { (b: B) throws(E) in
            try lhs(a, b)
        }
    }
}

public func inverseCurry<A, B, C, E: Error>(
    _ f: @escaping (A, B) throws(E) -> C
) -> (B) -> (A) throws(E) -> C {
    { (a: A) in
        { (b: B) throws(E) in
            try f(a, b)
        }
    }<!
}

// MARK: Backwards Chain / Compose (<<<)
infix operator <<<: Composition
postfix operator <<<

public func <<< <A, B, C, E: Error>(
    lhs: @escaping (B) throws(E) -> C,
    rhs: @escaping (A) throws(E) -> B
) -> (A) throws(E) -> C {
    { a in try lhs(rhs(a)) }
}
/// Uncurries a function.
/// - Parameter lhs: Function with arguments that returns another function with arguments.
/// - Returns: An uncurried function.
@available(macOS 14.0.0, *)
public postfix func <<< <A, B, C, E: Error>(
    lhs: @escaping (A) -> (B) throws(E) -> C
) -> (A, B) throws(E) -> C {
    { (a: A, b: B) throws(E) in
        try lhs(a)(b)
    }
}

@available(macOS 14.0.0, *)
public func inverseUncurry <A, B, C, E: Error>(
    _ f: @escaping (A) -> (B) throws(E) -> C
) -> (B, A) throws(E) -> C {
    { (b: B, a: A) throws(E) in
        try f(a)(b)
    }
}

// MARK: Forward Kleisli (>=>)
infix operator >=>: Composition

public func >=> <A, B, C, E: Error>(
    lhs: @escaping (A) throws(E) -> B?,
    rhs: @escaping (B) throws(E) -> C?
) -> (A) throws(E) -> C? {
    { (a: A) in try lhs(a).flatMap(rhs) }
}

public func >=> <A, B, C, E: Error>(
    lhs: @escaping (A) throws(E) -> some Sequence<B>,
    rhs: @escaping (B) throws(E) -> some Sequence<C>
) -> (A) throws(E) -> [C] {
    { (a: A) in
        var result = [C]()
        for element in try lhs(a) {
            result.append(contentsOf: try rhs(element))
        }
        return result
    }
}

// MARK: Reverse Kleisli (<=<)
infix operator <=<: Composition

public func <=< <A, B, C, E: Error>(
    lhs: @escaping (B) throws(E) -> C?,
    rhs: @escaping (A) throws(E) -> B?
) -> (A) throws(E) -> C? {
    { (a: A) in try rhs(a).flatMap(lhs) }
}

public func <=< <A, B, C, E: Error>(
    lhs: @escaping (B) throws(E) -> [C],
    rhs: @escaping (A) throws(E) -> [B]
) -> (A) throws(E) -> [C] {
    { a in
        var result = [C]()
        for element in try rhs(a) {
            result.append(contentsOf: try lhs(element))
        }
        return result
    }
}
// MARK: Setter (>&>)
infix operator >&>: Composition

public extension WritableKeyPath {
    /// Creates a setter for a given element.
    /// - Parameters:
    ///   - lhs: Reference to the property being set.
    ///   - rhs: Value being set.
    ///
    /// - Returns: Setter function.
    static func >&> <E: Error>(
        lhs: WritableKeyPath<Root, Value>,
        rhs: @autoclosure @escaping () throws(E) -> Value
    ) -> (inout Root) throws(E) -> Void {
        { $0[keyPath: lhs] = try rhs() }
    }
    /// Creates a setter for a given element.
    /// - Parameters:
    ///   - lhs: Reference to the property being set.
    ///   - rhs: Mutation applied to the property.
    ///
    /// - Returns: Setter function.
    static func >&> <E: Error>(
        lhs: WritableKeyPath<Root, Value>,
        rhs: @escaping (inout Value) throws(E) -> Void
    ) -> (inout Root) throws(E) -> Void {
        { try rhs(&$0[keyPath: lhs]) }
    }
    /// Creates a setter for a given element.
    /// - Parameters:
    ///   - lhs: Reference to the property being set.
    ///   - rhs: Transformation applied to the value.
    ///
    /// - Returns: Setter function.
    static func >&> <E: Error>(
        lhs: WritableKeyPath<Root, Value>,
        rhs: @escaping (Value) throws(E) -> Value
    ) -> (inout Root) throws(E) -> Void {
        { $0[keyPath: lhs] = try rhs($0[keyPath: lhs]) }
    }
}

// MARK: Flip (<!)
postfix operator <!
/// Flips a function with arguments that returns a function with arguments
/// - Parameter lhs: Function to be flipped
/// - Returns: Flipped function.
public postfix func <! <A, B, C, E: Error>(
    _ f: @escaping (A) -> (B) throws(E) -> C
) -> (B) -> (A) throws(E) -> C {
    { (b: B) in
        { (a: A) throws(E) in
            try f(a)(b)
        }
    }
}
