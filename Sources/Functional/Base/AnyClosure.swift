//
//  AnyClosure.swift
//
//
//  Created by Martônio Júnior on 20/11/23.
//

/// Short-hand alias for an erased closure.
public typealias ErasedClosure<C: Closure> = AnyClosure<C.Input, C.Output, C.Error>
/// Type-erased closure.
public struct AnyClosure<Input, Output, E: Error> {
    // MARK: Variables
    /// Closure to be executed.
    public let f: (Input) async throws(E) -> Output
    // MARK: Initializers
    /// Wraps a given function as a closure.
    /// - Parameter f: Function to be executed.
    public init(_ f: @escaping (Input) async throws(E) -> Output) {
        self.f = f
    }
    /// Erases a given closure.
    /// - Parameter closure: Closure.
    public init(_ closure: some Closure<Input, Output, E>) {
        self.f = closure.run
    }
}

// MARK: Self: Closure
extension AnyClosure: Closure {
    // swiftlint:disable:next missing_docs
    public func run(_ input: Input) async throws(E) -> Output {
        try await f(input)
    }
}

// MARK: Closure (EX)
public extension Closure {
    /// Maps a closure to an async function.
    /// - Parameter transform: Transforms the output of the closure.
    /// - Returns: `AnyClosure` that combines the two functions.
    func mapAsync<T>(
        _ transform: @escaping (Output) async throws(Error) -> T,
    ) -> AnyClosure<Input, T, Error> {
        let f: (Input) async throws(Error) -> T = { try await transform(run($0)) }

        return .init(f)
    }
    /// Pullbacks a closure via an async function.
    /// - Parameter transform: Transforms an input to the closure's input.
    /// - Returns: `AnyClosure` that combines the two functions.
    func pullbackAsync<T>(
        _: T.Type = T.self,
        _ transform: @escaping (T) async throws(Error) -> Input
    ) -> AnyClosure<T, Output, Error> {
        let f: (T) async throws(Error) -> Output = { try await run(transform($0)) }

        return .init(f)
    }
}
