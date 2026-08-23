//
//  Cast.swift
//  Minimal
//
//  Created by Martônio Júnior on 18/07/2026.
//

/// Casts the value to a type dynamically inferred at it's call site.
/// - Parameter value: Value to be cast.
/// - Throws: `CancellationError` when casting fails.
/// - Returns: Casted value.
@available(macOS 10.15, *)
public func cast<Value, T>(_ value: Value) throws(CancellationError) -> T {
    guard case let cast as T = value else { throw .init() }

    return cast
}
