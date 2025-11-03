//
//  Condition.swift
//  Core
//
//  Created by Martônio Júnior on 21/01/25.
//

public typealias Condition<T> = (T) -> Bool

// MARK: Function (EX)
@available(macOS 14.0.0, *)
@available(iOS 17.0.0, *)
public extension Function where Output == Bool {
    static func equals<T: Sendable>(_ element: T) -> Function<T, Bool> where T: Equatable {
        .init { $0 == element }
    }
}
