//
//  Command.swift
//  
//
//  Created by Martônio Júnior on 23/09/23.
//

import Foundation

public typealias Command = () async throws -> Void

// MARK: Sequence
public extension Sequence where Element == Command {
    func callAll() async throws {
        for item in self {
            try await item()
        }
    }
}
