//
//  Async.swift
//  Core
//
//  Created by Martônio Júnior on 25/04/2025.
//

// MARK: Async
@available(macOS 10.15, *)
public func async<T>(
    _: T.Type = T.self,
    f: @escaping () -> T
) async -> T {
    await withCheckedContinuation { continuation in
        continuation.resume(returning: f())
    }
}

@available(macOS 10.15, *)
public func async<T, E: Error>(
    _: T.Type = T.self,
    f: @escaping () throws(E) -> T
) async throws -> T {
    try await withCheckedThrowingContinuation { continuation in
        do {
            continuation.resume(returning: try f())
        } catch {
            continuation.resume(throwing: error)
        }
    }
}

// MARK: Race
@available(macOS 10.15, *)
public func race<T: Sendable>(
    _ lhs: @Sendable @escaping () async throws -> T,
    _ rhs: @Sendable @escaping () async throws -> T
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask { try await lhs() }
        group.addTask { try await rhs() }

        return try await group.next()!
    }
}

@available(macOS 10.15, *)
public func race<T: Sendable>(
    _ options: [@Sendable () async throws -> T]
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        for option in options {
            group.addTask { try await option() }
        }

        return try await group.next()!
    }
}
