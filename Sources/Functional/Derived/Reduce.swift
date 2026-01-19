//
//  Reduce.swift
//  Minimal
//
//  Created by Martônio Júnior on 18/09/2025.
//

public typealias Reduce<A, B> = Closure<(A, B), A, Never>
