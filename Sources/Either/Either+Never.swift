//
//  Either+Never.swift
//  Minimal
//
//  Created by Martônio Júnior on 29/07/2026.
//

// MARK: Self.Left == Never
public extension Either where Left == Never {
    /// Unconditional unwrap, as there only can be right-side values.
    var unwrapped: Right {
        switch self {
            case let .right(right): right
        }
    }
}

// MARK: Self.Right == Never
public extension Either where Right == Never {
    /// Unconditional unwrap, as there only can be left-side values.
    var unwrapped: Left {
        switch self {
            case let .left(left): left
        }
    }
}
