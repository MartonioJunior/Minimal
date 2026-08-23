//
//  Condition.swift
//  Minimal
//
//  Created by Martônio Júnior on 21/01/25.
//

/// Short-hand alias for a predicate closure
public typealias Condition<T> = Closure<T, Bool, Never>
