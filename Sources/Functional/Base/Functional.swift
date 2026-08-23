//
//  Functional.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/08/2026.
//

/// Element of functional programming with it's own inputs and outputs.
public protocol Functional {
    /// Type representing the input parameters.
    associatedtype Input
    /// Type representing the output of the function.
    associatedtype Output
    /// Type representing all possible errors that can be encountered.
    associatedtype Error: Swift.Error
}
