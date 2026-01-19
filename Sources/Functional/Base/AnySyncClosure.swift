//
//  AnySyncClosure.swift
//  Minimal
//
//  Created by Martônio Júnior on 31/12/2025.
//

import Foundation

public typealias ErasedSyncClosure<C: SyncClosure> = AnySyncClosure<C.Input, C.Output, C.Error>

public struct AnySyncClosure<Input, Output, E: Error> {
    // MARK: Variables
    public let raw: (Input) throws(E) -> Output

    var async: ErasedClosure<Self> { .init(raw) }

    // MARK: Initializers
    public init(_ raw: @escaping (Input) throws(E) -> Output) {
        self.raw = raw
    }

    public init<C: SyncClosure>(_ closure: C) where Input == C.Input, Output == C.Output, E == C.Error {
        self.raw = closure.run
    }

    // MARK: Methods
    func erased() -> ErasedSyncClosure<Self> { self }

    func erased<C: SyncClosure>(_ wrapper: (@escaping (Input) throws(Error) -> Output) -> C) -> C {
        wrapper(raw)
    }
}

// MARK: DotSyntax
public extension SyncClosure {
    static func composing<S: Sequence, T, I, O, E>(
        _ elements: S,
        evaluate: @escaping (I, S.Element) -> T,
        compose: @escaping (S, (S.Element) -> T) throws(E) -> O
    ) -> Self where Self == AnySyncClosure<I, O, E> {
        let f: (I) throws(E) -> O = { input in
            try compose(elements) { evaluate(input, $0) }
        }

        return .init(f)
    }
}

// MARK: Self: SyncClosure
extension AnySyncClosure: SyncClosure {
    public func run(_ input: Input) throws(E) -> Output {
        try raw(input)
    }
}

// MARK: SyncClosure (EX)
public extension SyncClosure {
    func erased() -> ErasedSyncClosure<Self> { .init(self) }

    func erased<C: SyncClosure>(_ wrapper: (@escaping (Input) throws(Error) -> Output) -> C) -> C {
        wrapper(run)
    }

    func pipe<T>(
        _ transform: @escaping (Output) throws(Error) -> T
    ) -> AnySyncClosure<Input, T, Error> {
        let f: (Input) throws(Error) -> T = { try transform(run($0)) }

        return .init(f)
    }

    func pullback<T>(
        _: T.Type = T.self,
        _ transform: @escaping (T) throws(Error) -> Input
    ) -> AnySyncClosure<T, Output, Error> {
        let f: (T) throws(Error) -> Output = { try run(transform($0)) }

        return .init(f)
    }
}
