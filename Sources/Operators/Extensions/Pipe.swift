//
//  Pipe.swift
//  Core
//
//  Created by Martônio Júnior on 16/04/2025.
//

public func pipe<A, B>(
    _ f: @escaping () -> A,
    _ g: @escaping (_ a: A) -> B
) -> () -> B {
    { g(f()) }
}

public func pipe<A, B>(
    _ f: @escaping () throws -> A,
    _ g: @escaping (_ a: A) throws -> B
) -> () throws -> B {
    { try g(f()) }
}
