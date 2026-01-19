//
//  Closure+Comparable.swift
//  Trinkets
//
//  Created by Martônio Júnior on 23/11/2025.
//

// MARK: Output: Comparable
public extension Closure where Output: Comparable {
    static func || (lhs: Self, rhs: Self) -> ErasedClosure<Self> {
        let f: (Input) async throws(Error) -> Output = {
            try max(await lhs.run($0), await rhs.run($0))
        }

        return .init(f)
    }

    static func && (lhs: Self, rhs: Self) -> ErasedClosure<Self> {
        let f: (Input) async throws(Error) -> Output = {
            try min(await lhs.run($0), await rhs.run($0))
        }

        return .init(f)
    }

    static func < (lhs: Self, rhs: Self) -> AnyClosure<Input, Bool, Error> {
        let f: (Input) async throws(Error) -> Bool = {
            try await lhs.run($0) < rhs.run($0)
        }

        return .init(f)
    }

    static func <= (lhs: Self, rhs: Self) -> AnyClosure<Input, Bool, Error> {
        let f: (Input) async throws(Error) -> Bool = {
            try await lhs.run($0) <= rhs.run($0)
        }

        return .init(f)
    }

    static func >= (lhs: Self, rhs: Self) -> AnyClosure<Input, Bool, Error> {
        let f: (Input) async throws(Error) -> Bool = {
            try await lhs.run($0) >= rhs.run($0)
        }

        return .init(f)
    }

    static func > (lhs: Self, rhs: Self) -> AnyClosure<Input, Bool, Error> {
        let f: (Input) async throws(Error) -> Bool = {
            try await lhs.run($0) > rhs.run($0)
        }

        return .init(f)
    }
}

public extension SyncClosure where Output: Comparable {
    static func || (lhs: Self, rhs: Self) -> ErasedSyncClosure<Self> {
        let f: (Input) throws(Error) -> Output = {
            try max(lhs.run($0), rhs.run($0))
        }

        return .init(f)
    }

    static func && (lhs: Self, rhs: Self) -> ErasedSyncClosure<Self> {
        let f: (Input) throws(Error) -> Output = {
            try min(lhs.run($0), rhs.run($0))
        }

        return .init(f)
    }

    static func < (lhs: Self, rhs: Self) -> AnySyncClosure<Input, Bool, Error> {
        let f: (Input) throws(Error) -> Bool = {
            try lhs.run($0) < rhs.run($0)
        }

        return .init(f)
    }

    static func <= (lhs: Self, rhs: Self) -> AnySyncClosure<Input, Bool, Error> {
        let f: (Input) throws(Error) -> Bool = {
            try lhs.run($0) <= rhs.run($0)
        }

        return .init(f)
    }

    static func >= (lhs: Self, rhs: Self) -> AnySyncClosure<Input, Bool, Error> {
        let f: (Input) throws(Error) -> Bool = {
            try lhs.run($0) >= rhs.run($0)
        }

        return .init(f)
    }

    static func > (lhs: Self, rhs: Self) -> AnySyncClosure<Input, Bool, Error> {
        let f: (Input) throws(Error) -> Bool = {
            try lhs.run($0) > rhs.run($0)
        }

        return .init(f)
    }
}

@available(macOS 13.0.0, *)
public func max<Input, Output: Comparable, Error>(
    lhs: some SyncClosure<Input, Output, Error>,
    _ elements: any SyncClosure<Input, Output, Error>...
) -> AnySyncClosure<Input, Output, Error> {
    elements.reduce(lhs.erased()) { $0 || $1.erased() }
}

@_disfavoredOverload
public func max<Input, Output: Comparable, Error>(
    lhs: some SyncClosure<Input, Output, Error>,
    _ elements: AnySyncClosure<Input, Output, Error>...
) -> AnySyncClosure<Input, Output, Error> {
    elements.reduce(lhs.erased()) { $0 || $1 }
}

@available(macOS 13.0.0, *)
public func maxAsync<Input, Output: Comparable, Error>(
    lhs: some Closure<Input, Output, Error>,
    _ elements: any Closure<Input, Output, Error>...
) -> AnyClosure<Input, Output, Error> {
    elements.reduce(lhs.erasedAsync()) { $0 || $1.erasedAsync() }
}

@_disfavoredOverload
public func maxAsync<Input, Output: Comparable, Error>(
    lhs: some Closure<Input, Output, Error>,
    _ elements: AnyClosure<Input, Output, Error>...
) -> AnyClosure<Input, Output, Error> {
    elements.reduce(lhs.erasedAsync()) { $0 || $1 }
}

@available(macOS 13.0.0, *)
public func min<Input, Output: Comparable, Error>(
    lhs: some SyncClosure<Input, Output, Error>,
    _ elements: any SyncClosure<Input, Output, Error>...
) -> AnySyncClosure<Input, Output, Error> {
    elements.reduce(lhs.erased()) { $0 && $1.erased() }
}

@_disfavoredOverload
public func min<Input, Output: Comparable, Error>(
    lhs: some SyncClosure<Input, Output, Error>,
    _ elements: AnySyncClosure<Input, Output, Error>...
) -> AnySyncClosure<Input, Output, Error> {
    elements.reduce(lhs.erased()) { $0 && $1 }
}

@available(macOS 13.0.0, *)
public func minAsync<Input, Output: Comparable, Error>(
    lhs: some Closure<Input, Output, Error>,
    _ elements: any Closure<Input, Output, Error>...
) -> AnyClosure<Input, Output, Error> {
    elements.reduce(lhs.erasedAsync()) { $0 && $1.erasedAsync() }
}

public func minAsync<Input, Output: Comparable, Error>(
    lhs: some Closure<Input, Output, Error>,
    _ elements: AnyClosure<Input, Output, Error>...
) -> AnyClosure<Input, Output, Error> {
    elements.reduce(lhs.erasedAsync()) { $0 && $1 }
}
