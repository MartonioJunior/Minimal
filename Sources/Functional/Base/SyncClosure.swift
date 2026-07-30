//
//  SyncClosure.swift
//  Minimal
//
//  Created by Martônio Júnior on 31/12/2025.
//

/// Describes a closure that is run synchronously.
public protocol SyncClosure<Input, Output, Error>: Closure {
    /// Executes the closure.
    /// - Parameter input: Input of the closure.
    /// - Throws: Error for the closure.
    /// - Returns: Output of the closure.
    func run(_ input: Input) throws(Error) -> Output
}

// MARK: Default Implementation
public extension SyncClosure {
    /// Executes the closure.
    /// - Parameter input: Input of the closure.
    /// - Throws: Error for the closure.
    /// - Returns: Output of the closure.
    @inlinable
    func callAsFunction(_ input: Input) throws(Error) -> Output {
        try run(input)
    }
    /// Executes the closure.
    /// - Parameter input: Inputs of the closure.
    /// - Throws: Error for the closure.
    /// - Returns: Output of the closure.
    @inlinable
    func callAsFunction<each Inputs>(
        _ inputs: repeat each Inputs
    ) throws(Error) -> Output where Input == (repeat each Inputs) {
        let args = (repeat each inputs)
        return try callAsFunction(args)
    }
    /// Executes the closure with a completion.
    /// - Parameters:
    ///   - input: Input of the closure.
    ///   - completion: Completion executed when the closure is run successfully.
    /// - Throws: Error for the closure.
    /// - Returns: Output of the closure.
    func callAsFunction(
        _ input: Input,
        completion: (Output) -> Void
    ) throws(Error) -> Output {
        let output = try callAsFunction(input)
        completion(output)
        return output
    }
}
