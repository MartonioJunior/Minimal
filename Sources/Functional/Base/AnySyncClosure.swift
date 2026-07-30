//
//  AnySyncClosure.swift
//  Minimal
//
//  Created by Martônio Júnior on 31/12/2025.
//

import Foundation
/// Short-hand alias for an erased sync closure.
public typealias ErasedSyncClosure<C: SyncClosure> = AnySyncClosure<C.Input, C.Output, C.Error>
/// Type-erased synchronous closure.
public struct AnySyncClosure<Input, Output, E: Error> {
    // MARK: Variables
    /// Closure to be executed.
    public let f: (Input) throws(E) -> Output
    /// Turns the sync closure into an async one.
    public var async: ErasedClosure<Self> { .init(f) }
    // MARK: Initializers
    /// Wraps a given function as a closure.
    /// - Parameter f: Function to be executed.
    public init(_ f: @escaping (Input) throws(E) -> Output) {
        self.f = f
    }
    /// Erases a given closure.
    /// - Parameter closure: Closure.
    public init<C: SyncClosure>(_ closure: C) where Input == C.Input, Output == C.Output, E == C.Error {
        self.f = closure.run
    }
}

// MARK: Self: SyncClosure
extension AnySyncClosure: SyncClosure {
    // swiftlint:disable:next missing_docs
    public func run(_ input: Input) throws(E) -> Output {
        try f(input)
    }
}

// MARK: SyncClosure (EX)
public extension SyncClosure {
    /// Maps a closure to a sync function.
    /// - Parameter transform: Transforms the output of the closure.
    /// - Returns: `AnySyncClosure` that combines the two functions.
    func map<T>(
        _ transform: @escaping (Output) throws(Error) -> T
    ) -> AnySyncClosure<Input, T, Error> {
        let f: (Input) throws(Error) -> T = { try transform(run($0)) }

        return .init(f)
    }
    /// Pullbacks a closure via a sync function.
    /// - Parameter transform: Transforms an input to the closure's input.
    /// - Returns: `AnySyncClosure` that combines the two functions.
    func pullback<T>(
        _: T.Type = T.self,
        _ transform: @escaping (T) throws(Error) -> Input
    ) -> AnySyncClosure<T, Output, Error> {
        let f: (T) throws(Error) -> Output = { try run(transform($0)) }

        return .init(f)
    }
}
