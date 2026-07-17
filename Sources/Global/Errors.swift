//
//  Errors.swift
//  Core
//
//  Created by Martônio Júnior on 25/07/2025.
//

import Overture

// MARK: Throwing
public func throwing<each A, B, E: Error>(
    _ function: @escaping (repeat each A) -> Result<B, E>
) -> (repeat each A) throws(E) -> B {
    { (arguments: repeat each A) in
        try function(repeat (each arguments)).get()
    }
}

public func throwing<each A, B, E1: Error, E2: Error>(
    _ function: @escaping (repeat each A) throws(E1) -> B,
    map: @escaping (E1) -> E2
) -> (repeat each A) throws(E2) -> B {
    { (arguments: repeat each A) in
        try Result(repeat (each arguments), catching: function).mapError(map).get()
    }
}

// MARK: Result (EX)
public extension Result {
    /// Creates a new result based on the combination of a value with a throwing closure.
    /// - Parameters:
    ///   - value: Value passed in as function arguments.
    ///   - body: A potentially throwing closure to evaluate.
    init<each T>(
        _ value: repeat each T,
        catching body: (repeat each T) throws(Failure) -> Success
    ) {
        do {
            self = .success(try body(repeat (each value)))
        } catch let error as Failure {
            self = .failure(error)
        }
    }
    /// Attempts to cast an existential error into a typed one.
    /// - Returns: Result when it's able to cast the error successfully, `nil` otherwise.
    func compactMapError<E: Error>(as _: E.Type) -> Result<Success, E>? where Failure == any Error {
        do {
            return .success(try get())
        } catch let error as E {
            return .failure(error)
        } catch {
            return nil
        }
    }
}
