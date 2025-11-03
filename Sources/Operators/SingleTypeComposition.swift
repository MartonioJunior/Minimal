//
//  SingleTypeComposition.swift
//
//
//  Created by Martônio Júnior on 24/01/24.
//

import Foundation
import Overture

// MARK: Precedence Group
precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

// MARK: Operators
infix operator <>: SingleTypeComposition // Concat

// MARK: Methods (<>)
public func <> <A>(
    lhsFunction: @escaping (inout A) -> Void,
    rhsFunction: @escaping (inout A) -> Void
) -> (inout A) -> Void {
    concat(lhsFunction, rhsFunction)
}

public func <> <A>(
    lhsFunction: @escaping (inout A) throws -> Void,
    rhsFunction: @escaping (inout A) throws -> Void
) -> (inout A) throws -> Void {
    concat(lhsFunction, rhsFunction)
}

public func <> <A: AnyObject>(
    lhsFunction: @escaping (A) -> Void,
    rhsFunction: @escaping (A) -> Void
) -> (A) -> Void {
    concat(lhsFunction, rhsFunction)
}

public func <> <A: AnyObject>(
    lhsFunction: @escaping (A) throws -> Void,
    rhsFunction: @escaping (A) throws -> Void
) -> (A) throws -> Void {
    concat(lhsFunction, rhsFunction)
}
