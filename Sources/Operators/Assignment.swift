//
//  Assignment.swift
//  Minimal
//
//  Created by Martônio Júnior on 14/08/2026.
//

// MARK: AND Assignment (&&=)
infix operator &&=: AssignmentPrecedence

public extension Bool {
    /// Performs an AND assignment
    /// - Parameters:
    ///   - lhs: Value to be modified.
    ///   - rhs: Right-hand side boolean.
    static func &&= (lhs: inout Self, rhs: Self) {
        lhs = lhs && rhs
    }
}

// MARK: OR Assignment (||=)
infix operator ||=: AssignmentPrecedence

public extension Bool {
    /// Performs an OR assignment
    /// - Parameters:
    ///   - lhs: Value to be modified.
    ///   - rhs: Right-hand side boolean.
    static func ||= (lhs: inout Self, rhs: Self) {
        lhs = lhs || rhs
    }
}
