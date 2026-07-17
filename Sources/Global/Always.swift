//
//  Always.swift
//  Minimal
//
//  Created by Martônio Júnior on 21/10/2025.
//

// MARK: Always
/// Creates a closure that always returns the same value.
/// - Parameter value: Value to be returned
/// - Returns: Closure that always returns `value`, no matter it's parameters
public func always<each Input, Output>(_ value: @autoclosure @escaping () -> Output) -> (repeat each Input) -> Output {
    { (_: repeat each Input) in value() }
}
/// Creates a sendable closure that always returns the same value.
/// - Parameter value: Value to be returned
/// - Returns: Closure that always returns `value`, no matter it's parameters
public func alwaysSendable<each Input: Sendable, Output: Sendable>(
    _ value: @autoclosure @escaping @Sendable () -> Output
) -> @Sendable (repeat each Input) -> Output {
    { (_: repeat each Input) in value() }
}
// MARK: Noop
/// Gap method that can be used to plug into closure parameters that do nothing.
public func noop() {}
/// Gap method that can be used to plug into closure parameters that do nothing.
public func noop<each Input>(_: repeat (each Input)) {}
