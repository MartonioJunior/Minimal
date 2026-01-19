//
//  SyncClosure.swift
//  Minimal
//
//  Created by Martônio Júnior on 31/12/2025.
//

public protocol SyncClosure<Input, Output, Error>: Closure {
    func run(_ input: Input) throws(Error) -> Output
}

// MARK: Default Implementation
public extension SyncClosure {
    func callAsFunction(_ input: Input) throws(Error) -> Output {
        try run(input)
    }

    func callAsFunction<each Inputs>(
        _ inputs: repeat each Inputs
    ) throws(Error) -> Output where Input == (repeat each Inputs) {
        let args = (repeat each inputs)
        return try callAsFunction(args)
    }

    func callAsFunction(
        _ input: Input,
        completion: (Output) -> Void
    ) throws(Error) -> Output {
        let output = try callAsFunction(input)
        completion(output)
        return output
    }

    @_disfavoredOverload
    func sample(_ inputs: some Sequence<Input>) -> [(Input, Result<Output, Error>)] {
        inputs.map {
            do {
                let output = try run($0)
                return ($0, .success(output))
            } catch let error as Error {
                return ($0, .failure(error))
            } catch { fatalError("Unreachable state!") }
        }
    }

    func sample(_ inputs: some Sequence<Input>) -> [(Input, Output)] where Error == Never {
        inputs.map { ($0, run($0)) }
    }
}
