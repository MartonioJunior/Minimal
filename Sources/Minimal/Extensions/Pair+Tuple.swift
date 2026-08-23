//
//  Pair+Tuple.swift
//  Minimal
//
//  Created by Martônio Júnior on 29/07/2026.
//

public extension Pair {
    /// Tuple representation for this pair.
    @available(macOS 14, *)
    var tuple: Tuple<First, Second> {
        Tuple(first, second)
    }
    /// Converts a tuple of size 2 into a pair.
    /// - Parameter tuple: Tuple of size 2.
    /// - Returns: Pair with the elements of the tuple.
    @available(macOS 14, *)
    static func fromTuple(_ tuple: Tuple<First, Second>) -> Self {
        .init(tuple.0, tuple.1)
    }
}
