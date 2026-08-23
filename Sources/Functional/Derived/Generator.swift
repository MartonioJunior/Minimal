//
//  Generator.swift
//  Minimal
//
//  Created by Martônio Júnior on 21/01/25.
//

/// Short-hand alias for a closure that takes no parameters and returns an output or fails.
public typealias Generator<Output, Failure: Error> = Closure<Void, Output, Failure>
