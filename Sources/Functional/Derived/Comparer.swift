//
//  Comparer.swift
//  Minimal
//
//  Created by Martônio Júnior on 21/01/25.
//

public import Foundation
/// Short-hand alias for a closure that compares two values.
public typealias Comparer<T> = Closure<(T, T), ComparisonResult, Never>
