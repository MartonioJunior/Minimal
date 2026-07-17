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
    // swiftlint:disable:next missing_docs
    public static func < (_: Blank, _: Blank) -> Bool { false }
}

// MARK: Self: Equatable
extension Blank: Equatable {}

// MARK: Self: ExpressibleByNilLiteral
extension Blank: ExpressibleByNilLiteral {
    // swiftlint:disable:next missing_docs
    public init(nilLiteral _: ()) {}
}

// MARK: Self: Hashable
extension Blank: Hashable {}

// MARK: Self: Sendable
extension Blank: Sendable {}
