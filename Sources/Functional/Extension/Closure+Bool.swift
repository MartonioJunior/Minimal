//
//  Closure+Bool.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/11/2025.
//

// MARK: Output == Bool
public extension Closure where Output == Bool {
    static func alwaysAsync<I, E>() -> Self
    where Self == AnyClosure<I, Bool, E> {
        .init { _ in true }
    }

    func andAsync(_ predicate: @escaping (Input) async throws(Error) -> Bool) -> ErasedClosure<Self> {
        self && AnyClosure(predicate)
    }

    static func anyAsync<S: Sequence, I, E>(
        _ elements: S,
        check: @escaping (I, S.Element) -> Bool
    ) -> Self where Self == AnyClosure<I, Bool, E> {
        .composing(elements, evaluate: check) {
            $0.contains(where: $1)
        }
    }

    static func allAsync<S: Sequence, I, E>(
        _ elements: S,
        check: @escaping (Input, S.Element) -> Bool
    ) -> Self where Self == AnyClosure<I, Bool, E> {
        .composing(elements, evaluate: check) {
            $0.allSatisfy($1)
        }
    }

    static func neverAsync<I, E>() -> Self
    where Self == AnyClosure<I, Bool, E> {
        .init { _ in false }
    }

    func orAsync(_ predicate: @escaping (Input) async throws(Error) -> Bool) -> ErasedClosure<Self> {
        self || AnyClosure(predicate)
    }

    func toggleAsync() -> ErasedClosure<Self> { !self }

    static prefix func ! (lhs: Self) -> ErasedClosure<Self> {
        let f: (Input) async throws(Error) -> Output = {
            try await !lhs.run($0)
        }

        return .init(f)
    }

    static func || <C>(lhs: Self, rhs: C) -> ErasedClosure<Self>
    where C: Closure<Input, Output, Error> {
        let f: (Input) async throws(Error) -> Output = {
            let l = try await lhs.run($0)
            let r = try await rhs.run($0)
            return l || r
        }

        return .init(f)
    }

    static func && <C>(lhs: Self, rhs: C) -> ErasedClosure<Self>
    where C: Closure<Input, Output, Error> {
        let f: (Input) async throws(Error) -> Output = {
            let l = try await lhs.run($0)
            let r = try await rhs.run($0)
            return l && r
        }

        return .init(f)
    }
}

public extension SyncClosure where Output == Bool {
    static func always<I, E>() -> Self
    where Self == AnySyncClosure<I, Bool, E> {
        .init { _ in true }
    }

    func and(_ predicate: @escaping (Input) throws(Error) -> Bool) -> ErasedClosure<Self> {
        self && AnySyncClosure(predicate)
    }

    static func any<S: Sequence, I, E>(
        _ elements: S,
        check: @escaping (I, S.Element) -> Bool
    ) -> Self where Self == AnySyncClosure<I, Bool, E> {
        .composing(elements, evaluate: check) {
            $0.contains(where: $1)
        }
    }

    static func all<S: Sequence, I, E>(
        _ elements: S,
        check: @escaping (Input, S.Element) -> Bool
    ) -> Self where Self == AnySyncClosure<I, Bool, E> {
        .composing(elements, evaluate: check) {
            $0.allSatisfy($1)
        }
    }

    static func never<I, E>() -> Self
    where Self == AnySyncClosure<I, Bool, E> {
        .init { _ in false }
    }

    func or(_ predicate: @escaping (Input) throws(Error) -> Bool) -> ErasedClosure<Self> {
        self || AnySyncClosure(predicate)
    }

    func toggle() -> ErasedSyncClosure<Self> { !self }

    static prefix func ! (lhs: Self) -> ErasedSyncClosure<Self> {
        let f: (Input) throws(Error) -> Output = {
            try !lhs.run($0)
        }

        return .init(f)
    }

    static func || <C>(lhs: Self, rhs: C) -> ErasedSyncClosure<Self>
    where C: SyncClosure<Input, Output, Error> {
        let f: (Input) throws(Error) -> Output = {
            let l = try lhs.run($0)
            let r = try rhs.run($0)
            return l || r
        }

        return .init(f)
    }

    static func && <C>(lhs: Self, rhs: C) -> ErasedSyncClosure<Self>
    where C: SyncClosure<Input, Output, Error> {
        let f: (Input) throws(Error) -> Output = {
            let l = try lhs.run($0)
            let r = try rhs.run($0)
            return l && r
        }

        return .init(f)
    }
}
