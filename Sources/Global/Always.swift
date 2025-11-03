//
//  Always.swift
//  Minimal
//
//  Created by Martônio Júnior on 21/10/2025.
//

// MARK: Always
public func always<each T, U>(_ value: @autoclosure @escaping () -> U) -> (repeat each T) -> U {
    { (_: repeat each T) in value() }
}

public func alwaysSendable<each T: Sendable, U: Sendable>(
    _ value: @autoclosure @escaping @Sendable () -> U
) -> @Sendable (repeat each T) -> U {
    { (_: repeat each T) in value() }
}

// MARK: Noop
public let noop: Void = ()

// MARK: None
public func none() {}
