//
//  Action.swift
//  Minimal
//
//  Created by Martônio Júnior on 21/01/25.
//

/// Short-hand alias for a closure that returns nothing.
public typealias Action<each T> = Closure<(repeat each T), Void, Never>
