//
//  Either.swift
//  Minimal
//
//  Created by Martônio Júnior on 17/07/2026.
//

/// Data structure that enumerates one of two possibilities.
public enum Either<Left, Right> {
    // MARK: Cases
    /// Left-side element.
    case left(Left)
    /// Right-side element.
    case right(Right)
}

// MARK: Variables
public extension Either {
    /// Attempts to retrieve the left-side element.
    var left: Left? {
        match { $0 } or: { _ in nil }
    }
    /// Attempts to retrieve the right-side element.
    var right: Right? {
        match { _ in nil } or: { $0 }
    }
    /// `Either` with the order of elements swapped around.
    var swapped: Either<Right, Left> {
        switch self {
            case let .left(left): .right(left)
            case let .right(right): .left(right)
        }
    }
}

// MARK: Initializers
public extension Either {
    /// Creates an Either from a throwing closure that returns a value.
    /// - Parameters:
    ///   - body: Body of the closure to be evaluated.
    ///   - fallback: How to transform the error into a non-error value.
    init<E: Error>(
        catching body: () throws(E) -> Left,
        fallback: (E) -> Right
    ) {
        do {
            self = .left(try body())
        } catch let error as E {
            self = .right(fallback(error))
        }
    }
}

// MARK: Methods
public extension Either {
    /// Attempts to obtain a left-side value.
    /// - Parameter rightMap: Map to transform the right-side value into left-side.
    /// - Throws: `E` when the mapping fails.
    /// - Returns: Left-side value.
    func left<E: Error>(or rightMap: (Right) throws(E) -> Left) throws(E) -> Left {
        switch self {
            case let .left(left): left
            case let .right(right): try rightMap(right)
        }
    }
    /// Remaps the either's types to a new either.
    /// - Parameters:
    ///   - leftMap: Map to transform the left-side.
    ///   - rightMap: Map to transform the right-side.
    ///
    /// - Throws: `E` when a mapping fails.
    /// - Returns: `Either` with a transformed value.
    func map<A, B, E: Error>(
        _ leftMap: (Left) throws(E) -> A,
        or rightMap: (Right) throws(E) -> B
    ) throws(E) -> Either<A, B> {
        switch self {
            case let .left(left): .left(try leftMap(left))
            case let .right(right): .right(try rightMap(right))
        }
    }
    /// Remaps the either's types to a common target value.
    /// - Parameters:
    ///   - leftMap: Map to transform the left-side.
    ///   - rightMap: Map to transform the right-side.
    ///
    /// - Throws: `E` when a mapping fails.
    /// - Returns: Target value.
    func match<T, E: Error>(
        _ leftMap: (Left) throws(E) -> T,
        or rightMap: (Right) throws(E) -> T
    ) throws(E) -> T {
        switch self {
            case let .left(left): try leftMap(left)
            case let .right(right): try rightMap(right)
        }
    }
    /// Attempts to obtain a right-side value.
    /// - Parameter leftMap: Map to transform the left-side value into right-side.
    /// - Throws: `E` when the mapping fails.
    /// - Returns: Right-side value.
    func right<E: Error>(or leftMap: (Left) throws(E) -> Right) throws(E) -> Right {
        switch self {
            case let .left(left): try leftMap(left)
            case let .right(right): right
        }
    }
}

// MARK: Self: Comparable
extension Either: Comparable where Left: Comparable, Right: Comparable {
    // swiftlint:disable:next missing_docs
    public static func < (lhs: Either, rhs: Either) -> Bool {
        switch (lhs, rhs) {
            case let (.left(lhs), .left(rhs)):
                return lhs < rhs
            case let (.right(lhs), .right(rhs)):
                return lhs < rhs
            case (.left, .right):
                return true
            case (.right, .left):
                return false
        }
    }
}

// MARK: Self: Decodable
extension Either: Decodable where Left: Decodable, Right: Decodable {}

// MARK: Self: Encodable
extension Either: Encodable where Left: Encodable, Right: Encodable {}

// MARK: Self: Equatable
extension Either: Equatable where Left: Equatable, Right: Equatable {}

// MARK: Self: Error
extension Either: Error where Left: Error, Right: Error {}

// MARK: Self: Hashable
extension Either: Hashable where Left: Hashable, Right: Hashable {}

// MARK: Self: Sendable
extension Either: Sendable where Left: Sendable, Right: Sendable {}

// MARK: Self.Left == Self.Right
public extension Either where Left == Right {
    /// Unconditional unwrap to it's actual type.
    var unwrapped: Left {
        switch self {
            case let .left(left): left
            case let .right(right): right
        }
    }
}
