//
//  AnySendableClosure.swift
//  Minimal
//
//  Created by Martônio Júnior on 07/01/2026.
//

import Foundation

public typealias ErasedSendableClosure<C: Closure> = AnySendableClosure<C.Input, C.Output, C.Error>

public struct AnySendableClosure<Input, Output, E: Error> {
    // MARK: Variables
    public let raw: @Sendable (Input) async throws(E) -> Output

    // MARK: Initializers
    public init(_ raw: @escaping @Sendable (Input) async throws(E) -> Output) {
        self.raw = raw
    }

    public init<C: Closure & Sendable>(_ closure: C) where Input == C.Input, Output == C.Output, E == C.Error {
        self.raw = closure.run
    }

    // MARK: Methods
    public func erasedAsync() -> ErasedSendableClosure<Self> { self }

    public func erasedAsyncMap<C: Closure>(_ wrapper: (@escaping (Input) async throws(Error) -> Output) -> C) -> C {
        wrapper(raw)
    }
}

// MARK: DotSyntax
public extension Closure {
    static func composing<S: Sequence & Sendable, T, I, O, E>(
        _ elements: S,
        evaluate: @escaping @Sendable (I, S.Element) -> T,
        compose: @escaping @Sendable (S, (S.Element) -> T) async throws(E) -> O
    ) -> Self where Self == AnySendableClosure<I, O, E> {
        let f: @Sendable (I) async throws(E) -> O = { input in
            try await compose(elements) { evaluate(input, $0) }
        }

        return .init(f)
    }

    static func sync<I, O, E>(
        _ f: @escaping @Sendable (I) throws(E) -> O
    ) -> Self where Self == AnySendableClosure<I, O, E> {
        .init(f)
    }
}

// MARK: Self: Closure
extension AnySendableClosure: Closure {
    public func run(_ input: Input) async throws(E) -> Output {
        try await raw(input)
    }
}

// MARK: Closure (EX)
public extension Closure where Self: Sendable {
    func erasedAsync() -> ErasedSendableClosure<Self> { .init(self.run) }

    func erasedAsyncMap<C: Closure>(_ wrapper: (@escaping (Input) async throws(Error) -> Output) -> C) -> C {
        wrapper(run)
    }

    func pipeAsync<T>(
        _ transform: @escaping @Sendable (Output) async throws(Error) -> T,
    ) -> AnySendableClosure<Input, T, Error> {
        let f: @Sendable (Input) async throws(Error) -> T = { try await transform(run($0)) }

        return .init(f)
    }

    func pullbackAsync<T>(
        _: T.Type = T.self,
        _ transform: @escaping @Sendable (T) async throws(Error) -> Input
    ) -> AnySendableClosure<T, Output, Error> {
        let f: @Sendable (T) async throws(Error) -> Output = { try await run(transform($0)) }

        return .init(f)
    }
}
