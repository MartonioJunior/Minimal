//
//  Prototype.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/09/23.
//

/// Modifier that creates new instances of a type
public typealias Prototype<Value> = Closure<Value, Value, Never>
