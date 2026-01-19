//
//  Closure+Void.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/11/2025.
//

// MARK: Input == Void
public extension Closure where Input == Void {
    func run() async throws(Error) -> Output { try await run(()) }
}

public extension SyncClosure where Input == Void {
    func run() throws(Error) -> Output { try run(()) }
}

// MARK: Output == Void
public extension Closure {
    var toVoidAsync: AnyClosure<Input, Void, Error> {
        let f: (Input) async throws(Error) -> Void = {
            _ = try await run($0)
        }

        return .init(f)
    }
}

public extension SyncClosure {
    var toVoid: AnySyncClosure<Input, Void, Error> {
        let f: (Input) throws(Error) -> Void = {
            _ = try run($0)
        }

        return .init(f)
    }
}

public extension Closure where Output == Void {
    func thenAsync(_ next: Self) -> AnyClosure<Input, Void, Error> {
        let f: (Input) async throws(Error) -> Void = {
            try await run($0)
            try await next.run($0)
        }

        return .init(f)
    }
}

public extension SyncClosure where Output == Void {
    func then(_ next: Self) -> AnySyncClosure<Input, Void, Error> {
        let f: (Input) throws(Error) -> Void = {
            try run($0)
            try next.run($0)
        }

        return .init(f)
    }
}

// MARK: Sequence
public extension Sequence where Element: Closure, Element.Input == Void, Element.Output == Void {
    func runAsyncAll() async throws(Element.Error) {
        for item in self {
            try await item.run()
        }
    }
}

public extension Sequence where Element: SyncClosure, Element.Input == Void, Element.Output == Void {
    func runAll() throws(Element.Error) {
        for item in self {
            try item.run()
        }
    }
}
