//
//  Either+AlternativeReturn.swift
//  Minimal
//
//  Created by Martônio Júnior on 29/07/2026.
//

// (Deprecated on Swift 2.0, but still declared, so the below is not yet required)
// infix operator ~>: ForwardApplication
public extension Either {
    /// Provides an alternative return for the value is on the right-side of `Either`.
    /// - Parameters:
    ///   - lhs: Either.
    ///   - rhs: Transformation from right-side to left-side.
    ///
    /// - Throws: `E` when mapping using `rhs` fails.
    /// - Returns: Value in the left-side type.
    static func ~> <E: Error>(
        lhs: Self,
        rhs: (Right) throws(E) -> Left
    ) throws(E) -> Left {
        try lhs.left(or: rhs)
    }
    /// Provides an alternative return for the value is on the left-side of `Either`.
    /// - Parameters:
    ///   - lhs: Either.
    ///   - rhs: Transformation from left-side to right-side.
    ///
    /// - Throws: `E` when mapping using `rhs` fails.
    /// - Returns: Value in the right-side type.
    static func ~> <E: Error>(
        lhs: Self,
        rhs: (Left) throws(E) -> Right
    ) throws(E) -> Right {
        try lhs.right(or: rhs)
    }
}

// MARK: Global (EX)
/// Provides an alternative return to a given expression.
/// - Parameters:
///   - expression: Closure returning a value
///   - alternative: Error transformation to create the alternative value.
///
/// - Throws: `C` when the expression fails to return a value.
/// - Returns: Value returned by `expression`.
public func ~> <A, B: Error, C>(
    expression: @autoclosure () throws(B) -> A,
    alternative: (B) -> C
) -> Either<A, C> {
    switch Result(catching: expression) {
        case let .success(value): .left(value)
        case let .failure(error): .right(alternative(error))
    }
}
