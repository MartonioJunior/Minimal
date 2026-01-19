//
//  Errors.swift
//  Core
//
//  Created by Martônio Júnior on 25/07/2025.
//

// MARK: Throwing
public func throwing<each A, B, E: Error>(
    _ function: @escaping (repeat each A) -> Result<B, E>
) -> (repeat each A) throws(E) -> B {
    { (arguments: repeat each A) in
        try function(repeat (each arguments)).get()
    }
}

public func throwing<each A, B, E1: Error, E2: Error>(
    _ function: @escaping (repeat each A) throws(E1) -> B,
    map: @escaping (E1) -> E2
) -> (repeat each A) throws(E2) -> B {
    let resultFunction = unthrow(function)

    return { (arguments: repeat each A) in
        try resultFunction(repeat (each arguments)).mapError(map).get()
    }
}

// MARK: Unthrow
public func unthrow<A, E: Error>(
    _ function: @escaping () throws(E) -> A
) -> () -> Result<A, E> {
    {
        do {
            return .success(try function())
        } catch let error as E {
            return .failure(error)
        } catch {
            fatalError()
        }
    }
}

public func unthrow<each A, B, E: Error>(
    _ function: @escaping (repeat each A) throws(E) -> B
) -> (repeat each A) -> Result<B, E> {
    { (arguments: repeat each A) in
        do {
            return .success(try function(repeat (each arguments)))
        } catch let error as E {
            return .failure(error)
        } catch {
            fatalError()
        }
    }
}

public func unthrowAny<A, E: Error>(
    as _: E.Type,
    _ function: @escaping () throws -> A
) -> () -> Result<A?, E> {
    {
        do {
            return .success(try function())
        } catch let error as E {
            return .failure(error)
        } catch {
            return .success(nil)
        }
    }
}

public func unthrowAny<each A, B, E: Error>(
    as _: E.Type,
    _ function: @escaping (repeat each A) throws -> B
) -> (repeat each A) -> Result<B?, E> {
    { (arguments: repeat each A) in
        do {
            return .success(try function(repeat (each arguments)))
        } catch let error as E {
            return .failure(error)
        } catch {
            return .success(nil)
        }
    }
}
