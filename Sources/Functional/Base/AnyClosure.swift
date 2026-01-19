//
//  AnyClosure.swift
//
//
//  Created by Martônio Júnior on 20/11/23.
//

import Foundation

public typealias ErasedClosure<C: Closure> = AnyClosure<C.Input, C.Output, C.Error>

public struct AnyClosure<Input, Output, E: Error> {
    // MARK: Variables
    public let raw: (Input) async throws(E) -> Output

    // MARK: Initializers
    public init(_ raw: @escaping (Input) async throws(E) -> Output) {
        self.raw = raw
    }

    public init<C: Closure>(_ closure: C) where Input == C.Input, Output == C.Output, E == C.Error {
        self.raw = closure.callAsFunction
    }

    // MARK: Methods
    public func erasedAsync() -> ErasedClosure<Self> { self }

    public func erasedAsyncMap<C: Closure>(_ wrapper: (@escaping (Input) async throws(Error) -> Output) -> C) -> C {
        wrapper(raw)
    }
}

// MARK: DotSyntax
public extension Closure {
    static func composing<S: Sequence, T, I, O, E>(
        _ elements: S,
        evaluate: @escaping (I, S.Element) -> T,
        compose: @escaping (S, (S.Element) -> T) async throws(E) -> O
    ) -> Self where Self == AnyClosure<I, O, E> {
        let f: (I) async throws(E) -> O = { input in
            try await compose(elements) { evaluate(input, $0) }
        }

        return .init(f)
    }

    static func sync<I, O, E>(
        _ f: @escaping (I) throws(E) -> O
    ) -> Self where Self == AnyClosure<I, O, E> {
        .init(f)
    }
}

// MARK: Self: Closure
extension AnyClosure: Closure {
    public func run(_ input: Input) async throws(E) -> Output {
        try await raw(input)
    }
}

// MARK: Closure (EX)
public extension Closure {
    func erasedAsync() -> ErasedClosure<Self> { .init(self) }

    func erasedAsyncMap<C: Closure>(_ wrapper: (@escaping (Input) async throws(Error) -> Output) -> C) -> C {
        wrapper(run)
    }

    func pipeAsync<T>(
        _ transform: @escaping (Output) async throws(Error) -> T,
    ) -> AnyClosure<Input, T, Error> {
        let f: (Input) async throws(Error) -> T = { try await transform(run($0)) }

        return .init(f)
    }

    func pullbackAsync<T>(
        _: T.Type = T.self,
        _ transform: @escaping (T) async throws(Error) -> Input
    ) -> AnyClosure<T, Output, Error> {
        let f: (T) async throws(Error) -> Output = { try await run(transform($0)) }

        return .init(f)
    }
}
