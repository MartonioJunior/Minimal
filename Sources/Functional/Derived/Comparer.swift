//
//  Comparer.swift
//  Minimal
//
//  Created by Martônio Júnior on 21/01/25.
//

public typealias Comparer<T> = Closure<(T, T), Bool, Never>
