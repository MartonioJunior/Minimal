//
//  Distance.swift
//  Core
//
//  Created by Martônio Júnior on 28/09/2025.
//

public struct Distance<T> {
    var calculate: (T, T) -> T
}

// MARK: DotSyntax
public extension Distance where T: Numeric, T.Magnitude == T {
    static var euclidean: Self {
        .init { ($0 - $1).magnitude }
    }
}
