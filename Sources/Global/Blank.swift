//
//  Blank.swift
//  Minimal
//
//  Created by Martônio Júnior on 12/11/2025.
//

/// Type that can be used as a plug-in replacement for `Void` in cases where conformances to protocols are required
public struct Blank {}

// MARK: Self: Codable
extension Blank: Codable {}

// MARK: Self: Comparable
extension Blank: Comparable {
    public static func < (lhs: Blank, rhs: Blank) -> Bool { false }
}

// MARK: Self: Equatable
extension Blank: Equatable {}

// MARK: Self: ExpressibleByNilLiteral
extension Blank: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {}
}

// MARK: Self: Hashable
extension Blank: Hashable {}

// MARK: Self: Sendable
extension Blank: Sendable {}
