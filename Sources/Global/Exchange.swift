//
//  Exchange.swift
//  Core
//
//  Created by Martônio Júnior on 21/01/25.
//

// MARK: Exchange
public func exchange<T: ~Copyable>(
    _ prop: inout T,
    with value: consuming T,
    condition: (borrowing T, borrowing T) -> Bool
) -> T {
    if condition(prop, value) { return value }

    return exchange(&prop, with: value)
}
