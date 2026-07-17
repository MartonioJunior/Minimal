//
//  Either.swift
//  Minimal
//
//  Created by Martônio Júnior on 17/07/2026.
//

public enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

// MARK: Methods
public extension Either {
    func map<A, B, E: Error>(
        left leftMap: (Left) throws(E) -> A,
        right rightMap: (Right) throws(E) -> B
    ) throws(E) -> Either<A, B> {
        switch self {
            case let .left(left): .left(try leftMap(left))
            case let .right(right): .right(try rightMap(right))
        }
    }

    func match<T, E: Error>(
        left leftMap: (Left) throws(E) -> T,
        right rightMap: (Right) throws(E) -> T
    ) throws(E) -> T {
        switch self {
            case let .left(left): try leftMap(left)
            case let .right(right): try rightMap(right)
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
