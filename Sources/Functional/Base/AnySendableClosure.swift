//
//  AnySendableClosure.swift
//  Minimal
//
//  Created by Martônio Júnior on 07/01/2026.
//

/// Short-hand alias for an erased sendable closure.
public typealias ErasedSendableClosure<C: Closure> = AnySendableClosure<C.Input, C.Output, C.Error>
/// Type-erased Sendable closure.
public struct AnySendableClosure<Input, Output, E: Error> {
    // MARK: Variables
    /// Closure to be executed.
    public let f: @Sendable (Input) async throws(E) -> Output
    // MARK: Initializers
    /// Wraps a given function as a closure.
    /// - Parameter f: Function to be executed.
    public init(_ f: @escaping @Sendable (Input) async throws(E) -> Output) {
        self.f = f
    }
    /// Erases a given closure.
    /// - Parameter closure: Closure.
    public init<C: Closure & Sendable>(_ closure: C) where Input == C.Input, Output == C.Output, E == C.Error {
        self.f = closure.run
    }
}

// MARK: Self: Closure
extension AnySendableClosure: Closure {
    // swiftlint:disable:next missing_docs
    public func run(_ input: Input) async throws(E) -> Output {
        try await f(input)
    }
}

// MARK: Closure (EX)
public extension Closure where Self: Sendable {
    /// Maps a closure to an async function.
    /// - Parameter transform: Transforms the output of the closure.
    /// - Returns: `AnySendableClosure` that combines the two functions.
    func pipeAsync<T>(
        _ transform: @escaping @Sendable (Output) async throws(Error) -> T,
    ) -> AnySendableClosure<Input, T, Error> {
        let f: @Sendable (Input) async throws(Error) -> T = { try await transform(run($0)) }

        return .init(f)
    }
    /// Pullbacks a closure via an async function.
    /// - Parameter transform: Transforms an input to the closure's input.
    /// - Returns: `AnySendableClosure` that combines the two functions.
    func pullbackAsync<T>(
        _: T.Type = T.self,
        _ transform: @escaping @Sendable (T) async throws(Error) -> Input
    ) -> AnySendableClosure<T, Output, Error> {
        let f: @Sendable (T) async throws(Error) -> Output = { try await run(transform($0)) }

        return .init(f)
    }
}
