//
//  Exchange.swift
//  Core
//
//  Created by Martônio Júnior on 21/01/25.
//

// MARK: Exchange
public func exchange<T: ~Copyable>(
    _ item: inout T,
    with value: consuming T,
    when condition: (borrowing T, borrowing T) -> Bool
) -> T {
    if condition(item, value) { return value }

    return exchange(&item, with: value)
}
