//
//  AbstractClass.swift
//  Minimal
//
//  Created by Martônio Júnior on 07/01/2026.
//

public func unimplemented() {
    fatalError("This method has not been implemented.")
}

public func unimplemented<T: AnyObject>(_ instance: T, abstract: T.Type = T.self) {
    precondition(type(of: instance) != abstract, "Calling implementation from abstract type.")
}
