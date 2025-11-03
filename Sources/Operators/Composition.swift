//
//  ForwardComposition.swift
//  
//
//  Created by Martônio Júnior on 24/01/24.
//

import Foundation
import Overture

// MARK: Precedence Group
precedencegroup Composition {
    associativity: left
    higherThan: ForwardApplication
}

// MARK: Operators
infix operator >>>: Composition // Pipe / Chain / Compose Forwards
infix operator <<<: Composition // Compose Backwards
// TODO: Add more methods for <<< operator

// MARK: Methods (>>>)
/// { g(f($0)) }
public func >>> <A, B, C>(
    lhsFunction: @escaping (A) -> B,
    rhsFunction: @escaping (B) -> C
) -> ((A) -> C) {
    pipe(lhsFunction, rhsFunction)
}

public func >>> <A, B, C>(
    lhsFunction: @escaping (A) throws -> B,
    rhsFunction: @escaping (B) throws -> C
) -> ((A) throws -> C) {
    pipe(lhsFunction, rhsFunction)
}

public func >>> <A, B, C>(
    lhsFunction: @escaping (A) -> B?,
    rhsFunction: @escaping (B) -> C?
) -> ((A) -> C?) {
    chain(lhsFunction, rhsFunction)
}

public func >>> <A, B, C>(
    lhsFunction: @escaping (A) throws -> B?,
    rhsFunction: @escaping (B) throws -> C?
) -> ((A) throws -> C?) {
    chain(lhsFunction, rhsFunction)
}

public func >>> <A, B, C>(
    lhsFunction: @escaping (A) -> [B],
    rhsFunction: @escaping (B) -> [C]
) -> ((A) -> [C]) {
    chain(lhsFunction, rhsFunction)
}

public func >>> <A, B, C>(
    lhsFunction: @escaping (A) throws -> [B],
    rhsFunction: @escaping (B) throws -> [C]
) -> ((A) throws -> [C]) {
    chain(lhsFunction, rhsFunction)
}

public func >>> <A, B>(
    value: @autoclosure @escaping () -> A,
    closure: @escaping (A) -> B
) -> () -> B {
    pipe(value, closure)
}

public func >>> <A, B>(
    value: @autoclosure @escaping () throws -> A,
    closure: @escaping (A) throws -> B
) -> () throws -> B {
    pipe(value, closure)
}

// MARK: Methods (<<<)
public func <<< <A, B, C>(
    lhsFunction: @escaping (B) -> C,
    rhsFunction: @escaping (A) -> B
) -> ((A) -> C) {
    compose(lhsFunction, rhsFunction)
}

public func <<< <A, B, C>(
    lhsFunction: @escaping (B) throws -> C,
    rhsFunction: @escaping (A) throws -> B
) -> ((A) throws -> C) {
    compose(lhsFunction, rhsFunction)
}
