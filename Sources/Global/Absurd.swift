//
//  Absurd.swift
//  Minimal
//
//  Created by Martônio Júnior on 21/10/2025.
//

/// Gap method that can be used to plug into closure parameters that receive `Never` and return a type.
public func absurd<Output>(_: Never) -> Output {}
