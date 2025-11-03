//
//  FunctionPurity.swift
//  Core
//
//  Created by Martônio Júnior on 30/01/25.
//

// MARK: mutating
public func mutating<A>(_ function: @escaping (A) -> A) -> ((inout A) -> Void) {
    { $0 = function($0) }
}

// MARK: purify
public func purify<A>(_ function: @escaping (inout A) -> Void) -> ((A) -> A) {
    {
        var copy = $0
        function(&copy)
        return copy
    }
}

public func purify<A, B>(_ function: @escaping (inout A) -> B) -> ((A) -> (A, B)) {
    {
        var copy = $0
        let result = function(&copy)
        return (copy, result)
    }
}
