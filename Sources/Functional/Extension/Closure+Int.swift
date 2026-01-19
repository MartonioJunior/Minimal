//
//  Closure+Int.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/11/2025.
//

// MARK: Output == Int
public extension Closure where Output == Int {
    static func count<S: Sequence, I, E>(
        _ elements: S,
        check: @escaping (I, S.Element) -> Bool
    ) -> Self where Self == AnyClosure<I, Int, E> {
        .composing(elements, evaluate: check) {
            $0.count(where: $1)
        }
    }
}

public extension SyncClosure where Output == Int {
    static func count<S: Sequence, I, E>(
        _ elements: S,
        check: @escaping (I, S.Element) -> Bool
    ) -> Self where Self == AnySyncClosure<I, Int, E> {
        .composing(elements, evaluate: check) {
            $0.count(where: $1)
        }
    }
}
