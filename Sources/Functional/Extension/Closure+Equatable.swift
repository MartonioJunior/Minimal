//
//  Closure+Equatable.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/11/2025.
//

// MARK: Input: Equatable
public extension Closure where Input: Equatable, Output == Bool {
    static func equals<I, E>(_ element: Input) -> Self
    where Self == AnyClosure<I, Bool, E> {
        .init { $0 == element }
    }
}

public extension SyncClosure where Input: Equatable, Output == Bool {
    static func equals<I, E>(_ element: Input) -> Self
    where Self == AnySyncClosure<I, Bool, E> {
        .init { $0 == element }
    }
}
