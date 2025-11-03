//
//  Function.swift
//
//
//  Created by Martônio Júnior on 20/11/23.
//

import Foundation

/// In Algebric terms, it describes the exponential of Output^Input
@available(iOS 17.0.0, *)
@available(macOS 14.0.0, *)
public struct Function<each Input, Output> {
    let raw: @Sendable (repeat each Input) async throws -> Output

    // MARK: Initializers
    public init(_ raw: @escaping @Sendable (repeat each Input) async throws -> Output) {
        self.raw = raw
    }

    // MARK: Methods
    public func callAsFunction(_ input: repeat each Input) async throws -> Output {
        try await raw(repeat each input)
    }
}

// MARK: Sendable
@available(iOS 17.0.0, *)
@available(macOS 14.0.0, *)
extension Function: Sendable where repeat each Input: Sendable {}
