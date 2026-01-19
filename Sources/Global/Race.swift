//
//  Race.swift
//  Core
//
//  Created by Martônio Júnior on 25/04/2025.
//

@available(macOS 10.15, *)
public func race<T: Sendable>(
    _ first: @Sendable @escaping () async throws -> T,
    _ next: (@Sendable () async throws -> T)...
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        for option in CollectionOfOne(first) + next {
            group.addTask { try await option() }
        }

        return try await group.next()!
    }
}
