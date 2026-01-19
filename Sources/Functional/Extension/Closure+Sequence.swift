//
//  Closure+Sequence.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/11/2025.
//

// MARK: Output: Sequence
public extension Closure where Output: Sequence {
    func compactedAsync<T>() -> AnyClosure<Input, [T], Error> where Output.Element == T? {
        pipeAsync { $0.compactMap(\.self) }
    }
}

public extension SyncClosure where Output: Sequence {
    func compacted<T>() -> AnySyncClosure<Input, [T], Error> where Output.Element == T? {
        pipe { $0.compactMap(\.self) }
    }
}
