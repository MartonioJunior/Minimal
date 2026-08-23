//
//  Closure.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/11/2025.
//

/// Describes a closure that is run asynchronously.
/// 
/// In Algebraic terms, it describes the exponential of (Output+Error)^Input
public protocol Closure<Input, Output, Error>: Functional {
    /// Executes the closure.
    /// - Parameter input: Input of the closure.
    /// - Throws: Error for the closure.
    /// - Returns: Output of the closure.
    func run(_ input: Input) async throws(Error) -> Output
}

// MARK: Default Implementation
public extension Closure {
    /// Executes the closure.
    /// - Parameter input: Input of the closure.
    /// - Throws: Error for the closure.
    /// - Returns: Output of the closure.
    @inlinable
    func callAsFunction(_ input: Input) async throws(Error) -> Output {
        try await run(input)
    }
    /// Executes the closure.
    /// - Parameter input: Inputs of the closure.
    /// - Throws: Error for the closure.
    /// - Returns: Output of the closure.
    @inlinable
    func callAsFunction<each Inputs>(
        _ inputs: repeat each Inputs
    ) async throws(Error) -> Output where Input == (repeat each Inputs) {
        try await run((repeat each inputs))
    }
    /// Executes the closure with a completion.
    /// - Parameters:
    ///   - input: Input of the closure.
    ///   - completion: Completion executed when the closure is run successfully.
    /// - Throws: Error for the closure.
    /// - Returns: Output of the closure.
    @inlinable
    func callAsFunction(
        _ input: Input,
        completion: (Output) -> Void
    ) async throws(Error) -> Output {
        let output = try await run(input)
        completion(output)
        return output
    }
}

// MARK: Self.Input == Never
public extension Closure {
    /// Executes the closure.
    /// - Throws: Error for the closure.
    /// - Returns: Output of the closure.
    func callAsFunction(_: Never) throws(Error) -> Output {}
}
