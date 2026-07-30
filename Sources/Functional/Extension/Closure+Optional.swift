//
//  Closure+Optional.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/11/2025.
//

// MARK: Output == Optional
public extension Closure {
    func optionalAsync(
        where predicate: @escaping (Output) -> Bool
    ) -> AnyClosure<Input, Output?, Error> {
        mapAsync { predicate($0) ? $0 : nil }
    }

    func isNone<T>() -> AnyClosure<Input, Bool, Error> where Output == T? {
        mapAsync { $0 == nil }
    }

    func isSome<T>() -> AnyClosure<Input, Bool, Error> where Output == T? {
        mapAsync { $0 != nil }
    }
}

public extension SyncClosure {
    func optional(
        where predicate: @escaping (Output) -> Bool
    ) -> AnySyncClosure<Input, Output?, Error> {
        map { predicate($0) ? $0 : nil }
    }

    func isNone<T>() -> AnySyncClosure<Input, Bool, Error> where Output == T? {
        map { $0 == nil }
    }

    func isSome<T>() -> AnySyncClosure<Input, Bool, Error> where Output == T? {
        map { $0 != nil }
    }
}
