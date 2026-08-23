//
//  Pair.swift
//  Minimal
//
//  Created by Martônio Júnior on 29/07/2026.
//

/// Data structure representing a pair of values.
public struct Pair<First, Second> {
    // MARK: Variables
    /// First element.
    public var first: First
    /// Second element.
    public var second: Second
    /// Pair with the order of elements swapped.
    public var swapped: Pair<Second, First> { .init(second, first) }
    // MARK: Initializers
    /// Creates a new pair.
    /// - Parameters:
    ///   - first: First element.
    ///   - second: Second element.
    public init(_ first: First, _ second: Second) {
        self.first = first
        self.second = second
    }
    // MARK: Methods
    /// Remaps the pair's values into a new pair.
    /// - Parameters:
    ///   - firstMap: Map to transform the first element.
    ///   - secondMap: Map to transform the second element.
    /// - Returns: `Pair` with transformed values.
    func map<A, B, E: Error>(
        _ firstMap: (First) throws(E) -> A,
        and secondMap: (Second) throws(E) -> B
    ) throws(E) -> Pair<A, B> {
        try .init(firstMap(first), secondMap(second))
    }
    /// Remaps the pair's values into a target value.
    /// - Parameter transform: Transformation to be used.
    /// - Returns: `T` value resulted from the transformation.
    func match<T, E: Error>(
        _ transform: (First, Second) throws(E) -> T
    ) throws(E) -> T {
        try transform(first, second)
    }
}

// MARK: Self: BitwiseCopyable
extension Pair: BitwiseCopyable where First: BitwiseCopyable, Second: BitwiseCopyable {}

// MARK: Self: Comparable
extension Pair: Comparable where First: Comparable, Second: Comparable {
    // swiftlint:disable:next missing_docs
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.first == rhs.first {
            lhs.first < rhs.first
        } else {
            lhs.second < rhs.second
        }
    }
}

// MARK: Self: CustomStringConvertible
extension Pair: CustomStringConvertible where First: CustomStringConvertible, Second: CustomStringConvertible {
    // swiftlint:disable:next missing_docs
    public var description: String { "(\(first), \(second))" }
}

// MARK: Self: Decodable
extension Pair: Decodable where First: Decodable, Second: Decodable {}

// MARK: Self: Encodable
extension Pair: Encodable where First: Encodable, Second: Encodable {}

// MARK: Self: Equatable
extension Pair: Equatable where First: Equatable, Second: Equatable {}

// MARK: Self: Error
extension Pair: Error where First: Error, Second: Error {}

// MARK: Self: Hashable
extension Pair: Hashable where First: Hashable, Second: Hashable {}

// MARK: Self: Sendable
extension Pair: Sendable where First: Sendable, Second: Sendable {}
