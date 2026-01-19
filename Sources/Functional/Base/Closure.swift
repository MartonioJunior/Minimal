//
//  Closure.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/11/2025.
//

/// In Algebric terms, it describes the exponential of (Output+Error)^Input
public protocol Closure<Input, Output, Error> {
    associatedtype Input
    associatedtype Output
    associatedtype Error: Swift.Error

    func run(_ input: Input) async throws(Error) -> Output
}

// MARK: Default Implementation
public extension Closure {
    func callAsFunction(_ input: Input) async throws(Error) -> Output {
        try await run(input)
    }

    func callAsFunction<each Inputs>(
        _ inputs: repeat each Inputs
    ) async throws(Error) -> Output where Input == (repeat each Inputs) {
        let args = (repeat each inputs)
        return try await callAsFunction(args)
    }

    func callAsFunction(
        _ input: Input,
        completion: (Output) -> Void
    ) async throws(Error) -> Output {
        let output = try await callAsFunction(input)
        completion(output)
        return output
    }

    @_disfavoredOverload
    func sampleAsync(_ inputs: some Sequence<Input>) async -> [(Input, Result<Output, Error>)] {
        var result: [(Input, Result<Output, Error>)] = []

        for input in inputs {
            do {
                let output = try await run(input)
                result.append((input, .success(output)))
            } catch let error {
                result.append((input, .failure(error)))
            }
        }

        return result
    }

    func sampleAsync(_ inputs: some Sequence<Input>) async -> [(Input, Output)] where Error == Never {
        var result: [(Input, Output)] = []

        for input in inputs {
            let output = await run(input)
            result.append((input, output))
        }

        return result
    }
}

// MARK: Self.Input == Never
public extension Closure {
    func callAsFunction(_: Never) throws(Error) -> Output {}
}
