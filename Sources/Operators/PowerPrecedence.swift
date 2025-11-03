//
//  PowerPrecedence.swift
//  Core
//
//  Created by Martônio Júnior on 16/04/2025.
//

// MARK: Precedence Group
precedencegroup PowerPrecedence {
    higherThan: MultiplicationPrecedence, AssignmentPrecedence
}

// MARK: Operators
infix operator **: PowerPrecedence // Power
infix operator **=: PowerPrecedence // Power (Mutable)

// MARK: Methods (**)

// MARK: Methods (**=)
