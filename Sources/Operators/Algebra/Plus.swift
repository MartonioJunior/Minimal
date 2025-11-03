//
//  Additive.swift
//
//
//  Created by Martônio Júnior on 05/10/23.
//

import Foundation

public protocol Plus {
    static func + (lhs: Self, rhs: Self) -> Self
}
