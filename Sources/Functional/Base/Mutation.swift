//
//  Mutation.swift
//  Minimal
//
//  Created by Martônio Júnior on 18/07/2026.
//

/// Closure that represents the mutation for a value.
public struct Mutation<Input, Output, E: Error> {
    // MARK: Variables
    /// Closure representing the mutation.
    public let f: (inout Input) throws(E) -> Output
    /// Creates a purified version of this mutation.
    var purified: some SyncClosure<Input, (Input, Output), E> {
        AnySyncClosure(purify(f))
    }
    // MARK: Initializers
    /// Creates a mutation from a closure.
    /// - Parameter f: Closure representing the mutation.
    public init(_ f: @escaping (inout Input) throws(E) -> Output) {
        self.f = f
    }
    /// Creates a mutation from a synchronous closure.
    /// - Parameter closure: Synchronous closure.
    public init(_ closure: some SyncClosure<Input, (Input, Output), E>) {
        self.f = mutating(closure.run)
    }
    // MARK: Methods
    /// Executes the closure.
    /// - Parameter input: Input of the closure.
    /// - Throws: Error for the closure.
    /// - Returns: Output of the closure.
    func run(_ input: inout Input) throws(E) -> Output {
        try f(&input)
    }
}

// MARK: Self.Output == Void
public extension Mutation where Output == Void {
    /// Creates a purified version of this mutation.
    var purified: some SyncClosure<Input, Input, E> {
        let map: (Input) throws(E) -> Input = {
            var copy = $0
            try f(&copy)
            return copy
        }

        return AnySyncClosure(map)
    }
    // Creates a mutation from a synchronous closure.
    /// - Parameter closure: Synchronous closure.
    init(_ closure: some SyncClosure<Input, Input, E>) {
        let f: (inout Input) throws(E) -> Output = {
            $0 = try closure($0)
        }

        self.f = f
    }
}

// MARK: SyncClosure (EX)
public extension SyncClosure where Input == Output {
    /// Creates a mutating version of this closure.
    var mutating: Mutation<Input, Void, Error> { .init(self) }
}

// MARK: Global Functions
/// Transforms a pure function into a mutating one.
/// - Parameter f: Pure function.
/// - Returns: Mutating function.
public func mutating<A, E: Error>(
    _ f: @escaping (A) throws(E) -> A
) -> (inout A) throws(E) -> Void {
    { $0 = try f($0) }
}
/// Transforms a pure function into a mutating one.
/// - Parameter f: Pure function.
/// - Returns: Mutating function.
public func mutating<A, B, E: Error>(
    _ f: @escaping (A) throws(E) -> (A, B)
) -> (inout A) throws(E) -> B {
    {
        let (result, output) = try f($0)
        $0 = result
        return output
    }
}
/// Purifies a mutating function.
/// - Parameter f: Mutating function.
/// - Returns: Pure function.
public func purify<A, E: Error>(
    _ f: @escaping (inout A) throws(E) -> Void
) -> (A) throws(E) -> A {
    {
        var copy = $0
        try f(&copy)
        return copy
    }
}
/// Purifies a mutating function.
/// - Parameter f: Mutating function.
/// - Returns: Pure function.
public func purify<A, B, E: Error>(
    _ f: @escaping (inout A) throws(E) -> B
) -> (A) throws(E) -> (A, B) {
    {
        var copy = $0
        let result = try f(&copy)
        return (copy, result)
    }
}
