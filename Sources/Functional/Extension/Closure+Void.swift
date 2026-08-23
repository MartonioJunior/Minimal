//
//  Closure+Void.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/11/2025.
//

// MARK: Input == Void
public extension Closure where Input == Void {
    /// Executes the given closure asynchronously.
    /// - Throws: Error when execution fails.
    func run() async throws(Error) -> Output { try await run(()) }
}

public extension SyncClosure where Input == Void {
    /// Executes the given closure synchronously.
    /// - Throws: Error when execution fails.
    func run() throws(Error) -> Output { try run(()) }
}

// MARK: Output == Void
public extension Closure {
    /// Async function that discards it's output.
    var toVoidAsync: AnyClosure<Input, Void, Error> {
        let f: (Input) async throws(Error) -> Void = {
            _ = try await run($0)
        }

        return .init(f)
    }
}

public extension SyncClosure {
    /// Synchronous function that discards it's output.
    var toVoid: AnySyncClosure<Input, Void, Error> {
        let f: (Input) throws(Error) -> Void = {
            _ = try run($0)
        }

        return .init(f)
    }
}

public extension Closure where Output == Void {
    /// Chains another method to the current closure.
    /// - Parameter next: Next method to be called after the closure.
    /// - Returns: Combined async closure.
    func thenAsync(_ next: Self) -> AnyClosure<Input, Void, Error> {
        let f: (Input) async throws(Error) -> Void = {
            try await run($0)
            try await next.run($0)
        }

        return .init(f)
    }
}

public extension SyncClosure where Output == Void {
    /// Chains another method to the current closure.
    /// - Parameter next: Next method to be called after the closure.
    /// - Returns: Combined synchronous closure.
    func then(_ next: Self) -> AnySyncClosure<Input, Void, Error> {
        let f: (Input) throws(Error) -> Void = {
            try run($0)
            try next.run($0)
        }

        return .init(f)
    }
}

// MARK: Sequence
public extension Sequence where Element: Closure, Element.Input == Void, Element.Output == Void {
    /// Attempts to run all methods asynchronously.
    /// - Throws: Error if any element run fails.
    func runAsyncAll() async throws(Element.Error) {
        for item in self {
            try await item.run()
        }
    }
}

public extension Sequence where Element: SyncClosure, Element.Input == Void, Element.Output == Void {
    /// Attempts to run all methods asynchronously.
    /// - Throws: Error if any element run fails.
    func runAll() throws(Element.Error) {
        for item in self {
            try item.run()
        }
    }
}
