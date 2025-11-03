//
//  Sync.swift
//  Core
//
//  Created by Martônio Júnior on 20/06/2025.
//

public import Foundation

/// Source: https://augmentedcode.io/2024/09/09/wrapping-async-await-with-a-completion-handler-in-swift/
@available(macOS 10.15, *)
public func sync(
    priority: TaskPriority? = nil,
    operation: @escaping @Sendable () async -> Void,
    queue: DispatchQueue = .main,
    completion: @escaping @Sendable () -> Void
) {
    Task(priority: priority) {
        await operation()
        queue.async {
            completion()
        }
    }
}

/// Source: https://augmentedcode.io/2024/09/09/wrapping-async-await-with-a-completion-handler-in-swift/
@available(macOS 10.15, *)
public func sync<E: Error>(
    priority: TaskPriority? = nil,
    operation: @escaping @Sendable () async throws(E) -> Void,
    queue: DispatchQueue = .main,
    completion: @escaping @Sendable (E?) -> Void
) {
    Task(priority: priority) {
        do {
            try await operation()
            queue.async {
                completion(nil)
            }
        } catch let error as E {
            queue.async {
                completion(error)
            }
        } catch {}
    }
}

/// Source: https://augmentedcode.io/2024/09/09/wrapping-async-await-with-a-completion-handler-in-swift/
@available(macOS 10.15, *)
public func sync<T, E: Error>(
    priority: TaskPriority? = nil,
    operation: @escaping @Sendable () async throws(E) -> T,
    queue: DispatchQueue = .main,
    completion: @escaping @Sendable (Result<T, E>) -> Void
) where T: Sendable {
    Task(priority: priority) {
        do {
            let value = try await operation()
            queue.async {
                completion(.success(value))
            }
        } catch let error as E {
            queue.async {
                completion(.failure(error))
            }
        } catch {}
    }
}
