//
//  Map.swift
//  Minimal
//
//  Created by Martônio Júnior on 21/01/25.
//

/// Short-hand alias for a closure that returns a transformed input.
public typealias Map<T> = Closure<T, T, Never>
