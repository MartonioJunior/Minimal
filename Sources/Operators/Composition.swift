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

public func >>> <A, B, each C, D, E: Error>(
    _ lhs: @escaping (A) throws(E) -> B,
    _ rhs: @escaping (B, repeat each C) throws(E) -> D
) -> (A, repeat each C) throws(E) -> D {
    { (a: A, c: repeat each C) in
        try rhs(lhs(a), repeat (each c))
    }
}

public func >>> <each A, B, C, E: Error>(
    _ lhs: @escaping (repeat each A) throws(E) -> B,
    _ rhs: @escaping (B) throws(E) -> C
) -> (repeat each A) throws(E) -> C {
    { (a: repeat each A) in
        try rhs(lhs(repeat each a))
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
public postfix func >>> <each A, B, C, E: Error>(
    lhs: @escaping (repeat each A, B) throws(E) -> C
) -> (repeat each A) -> (B) throws(E) -> C {
    { (a: repeat each A) in
        { (b: B) throws(E) in
            let f = AnySyncClosure(lhs)
            let input = (repeat each a, b)
            return try f.run(input)
        }
    }
}

public func inverseCurry<A, each B, C, E: Error>(
    _ f: @escaping (A, repeat each B) throws(E) -> C
) -> (repeat each B) -> (A) throws(E) -> C {
    { (a: A) in
        { (b: repeat each B) throws(E) in
            try f(a, repeat each b)
        }
    }<!
}

// MARK: Backwards Chain / Compose (<<<)
infix operator <<<: Composition
postfix operator <<<

public func <<< <each A, B, C, E: Error>(
    lhs: @escaping (B) throws(E) -> C,
    rhs: @escaping (repeat each A) throws(E) -> B
) -> (repeat each A) throws(E) -> C {
    rhs >>> lhs
}

public func <<< <A, B, each C, D, E: Error>(
    lhs: @escaping (B, repeat each C) throws(E) -> D,
    rhs: @escaping (A) throws(E) -> B
) -> (A, repeat each C) throws(E) -> D {
    rhs >>> lhs
}

public func <<< <each A, B, E: Error>(
    lhs: @escaping () throws(E) -> B,
    rhs: @escaping (repeat each A) throws(E) -> Void
) -> (repeat each A) throws(E) -> B {
    rhs >>> lhs
}
/// Uncurries a function.
/// - Parameter lhs: Function with arguments that returns another function with arguments.
/// - Returns: An uncurried function.
public postfix func <<< <A, each B, C, E: Error>(
    lhs: @escaping (A) throws(E) -> (repeat each B) throws(E) -> C
) -> (A, repeat each B) throws(E) -> C {
    { (a: A, b: repeat each B) throws(E) in
        try lhs(a)(repeat each b)
    }
}

public postfix func <<< <each A, B, E: Error>(
    lhs: @escaping () throws(E) -> (repeat each A) throws(E) -> B
) -> (repeat each A) throws(E) -> B {
    { (a: repeat each A) throws(E) in
        try lhs()(repeat each a)
    }
}

public func inverseUncurry<each A, B, C, E: Error>(
    _ f: @escaping (repeat each A) throws(E) -> (B) throws(E) -> C
) -> (B, repeat each A) throws(E) -> C {
    { (b: B, a: repeat each A) throws(E) in
        try f(repeat each a)(b)
    }
}

public func inverseUncurry<each A, B, each C, D, E: Error>(
    _ lhs: @escaping (repeat each A) throws(E) -> (B, repeat each C) throws(E) -> D
) -> (B, repeat each A) throws(E) -> (repeat each C) throws(E) -> D {
    { (b: B, a: repeat each A) throws(E) in
        { (c: repeat each C) throws(E) in
            try lhs(repeat each a)(b, repeat each c)
        }
    }
}

// MARK: Forward Kleisli (>=>)
infix operator >=>: Composition

public func >=> <each A, B, C, E: Error>(
    lhs: @escaping (repeat each A) throws(E) -> B?,
    rhs: @escaping (B) throws(E) -> C?
) -> (repeat each A) throws(E) -> C? {
    { (a: repeat each A) in try lhs(repeat each a).flatMap(rhs) }
}

public func >=> <each A, B, C, E: Error>(
    lhs: @escaping (repeat each A) throws(E) -> some Sequence<B>,
    rhs: @escaping (B) throws(E) -> some Sequence<C>
) -> (repeat each A) throws(E) -> [C] {
    { (a: repeat each A) in
        var result = [C]()
        for element in try lhs(repeat each a) {
            result.append(contentsOf: try rhs(element))
        }
        return result
    }
}

// MARK: Reverse Kleisli (<=<)
infix operator <=<: Composition

public func <=< <each A, B, C, E: Error>(
    lhs: @escaping (B) throws(E) -> C?,
    rhs: @escaping (repeat each A) throws(E) -> B?
) -> (repeat each A) throws(E) -> C? {
    { (a: repeat each A) in try rhs(repeat each a).flatMap(lhs) }
}

public func <=< <each A, B, C, E: Error>(
    lhs: @escaping (B) throws(E) -> some Sequence<C>,
    rhs: @escaping (repeat each A) throws(E) -> some Sequence<B>
) -> (repeat each A) throws(E) -> [C] {
    { (a: repeat each A) in
        var result = [C]()
        for element in try rhs(repeat each a) {
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
    static func >&> (
        lhs: WritableKeyPath<Root, Value>,
        rhs: @autoclosure @escaping () -> Value
    ) -> (inout Root) -> Void {
        { $0[keyPath: lhs] = rhs() }
    }
    /// Creates a setter for a given element using a given set of parameters.
    /// - Parameters:
    ///   - lhs: Reference to the property being set.
    ///   - rhs: Value being set.
    ///
    /// - Returns: Setter function.
    static func >&> <each A, E: Error>(
        lhs: WritableKeyPath<Root, Value>,
        rhs: @escaping (repeat each A) throws(E) -> Value
    ) -> (inout Root, repeat each A) throws(E) -> Void {
        { (root: inout Root, a: repeat each A) in
            root[keyPath: lhs] = try rhs(repeat each a)
        }
    }
    /// Creates a setter based on a mutating function.
    /// - Parameters:
    ///   - lhs: Reference to the property being set.
    ///   - rhs: Mutation applied to the property.
    ///
    /// - Returns: Setter function.
    static func >&> <T, E: Error>(
        lhs: WritableKeyPath<Root, Value>,
        rhs: @escaping (inout Value) throws(E) -> T
    ) -> (inout Root) throws(E) -> T {
        { try rhs(&$0[keyPath: lhs]) }
    }
    /// Creates a setter based on a pure function.
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
public postfix func <! <each A, each B, C, E: Error>(
    _ f: @escaping (repeat each A) -> (repeat each B) throws(E) -> C
) -> (repeat each B) -> (repeat each A) throws(E) -> C {
    { (b: repeat each B) in
        { (a: repeat each A) throws(E) in
            try f(repeat each a)(repeat each b)
        }
    }
}
