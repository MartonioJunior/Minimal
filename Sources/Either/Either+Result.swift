//
//  Either+Result.swift
//  Minimal
//
//  Created by Martônio Júnior on 29/07/2026.
//

// MARK: Self.Right: Error
public extension Either where Right: Error {
    /// Value remapped as a `Result`.
    var asResult: Result<Left, Right> {
        match { .success($0) } or: { .failure($0) }
    }
    /// Creates an Either from a Result description
    /// - Parameter result: Result.
    /// - Returns: Corresponding `Either` type, with left-side being success and right-side being failure.
    static func fromResult(_ result: Result<Left, Right>) -> Self {
        switch result {
            case let .success(left): .left(left)
            case let .failure(right): .right(right)
        }
    }
}
