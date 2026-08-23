//
//  Command.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/09/23.
//

/// Short-hand alias for a closure that is run with and returns no parameters.
public typealias Command = Closure<Void, Void, Never>
