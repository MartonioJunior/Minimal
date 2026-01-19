//
//  Operation.swift
//  Minimal
//
//  Created by Martônio Júnior on 21/01/25.
//

public typealias Operation<T> = Closure<(T, T), T, Never>
