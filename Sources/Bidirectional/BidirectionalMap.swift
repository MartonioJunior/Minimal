//
//  BidirectionalMap.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/08/2026.
//

/// Short-hand alias for a bi-directional map that does not throw an error.
public typealias Bimap<Input, Output> = BidirectionalMap<Input, Output, Never>
/// Closure that can be executed in both directions.
public struct BidirectionalMap<Input, Output, Failure: Error> {
    // MARK: Variables
    /// Closure that returns an output from input.
    public var forward: (Input) throws(Failure) -> Output
    /// Inverse closure of `forward`, obtaining input from the output.
    public var reverse: (Output) throws(Failure) -> Input
    /// `Bidirectional` that swaps around the forward direction of the closure.
    public var swapped: BidirectionalMap<Output, Input, Failure> {
        .init(reverse, reverse: forward)
    }
    // MARK: Initializers
    /// Creates a new bi-directional closure.
    /// - Parameters:
    ///   - forward: Closure that returns an output from input.
    ///   - reverse: Inverse closure of `forward`.
    public init(
        _ forward: @escaping (Input) throws(Failure) -> Output,
        reverse: @escaping (Output) throws(Failure) -> Input
    ) {
        self.forward = forward
        self.reverse = reverse
    }
    // MARK: Methods
    /// Maps the bi-directional closure.
    /// - Parameters:
    ///   - mapForward: Maps output to the new type.
    ///   - mapReverse: Maps the new type to the output.
    /// - Returns: New bi-directional closure.
    public func map<T>(
        _ mapForward: @escaping (Output) throws(Failure) -> T,
        reverse mapReverse: @escaping (T) throws(Failure) -> Output
    ) -> BidirectionalMap<Input, T, Failure> {
        let newForward: (Input) throws(Failure) -> T = { try mapForward(forward($0)) }
        let newReverse: (T) throws(Failure) -> Input = { try reverse(mapReverse($0)) }
        return .init(newForward, reverse: newReverse)
    }
    /// Maps the bi-directional closure using another bidirectional map.
    /// - Parameter transform: Bidirectional mapper used in the transformation.
    /// - Returns: New bi-directional closure.
    public func map<T>(
        _ transform: @autoclosure () -> BidirectionalMap<Output, T, Failure>
    ) -> BidirectionalMap<Input, T, Failure> {
        let mapper = transform()
        return map(mapper.forward, reverse: mapper.reverse)
    }
    /// Pulls back the bi-directional closure.
    /// - Parameters:
    ///   - mapForward: Maps new type to the input.
    ///   - mapReverse: Maps input to new type.
    /// - Returns: New bi-directional closure.
    public func pullback<T>(
        _ mapForward: @escaping (T) throws(Failure) -> Input,
        reverse mapReverse: @escaping (Input) throws(Failure) -> T
    ) -> BidirectionalMap<T, Output, Failure> {
        let newForward: (T) throws(Failure) -> Output = { try forward(mapForward($0)) }
        let newReverse: (Output) throws(Failure) -> T = { try mapReverse(reverse($0)) }
        return .init(newForward, reverse: newReverse)
    }
    /// Pulls back the bi-directional closure using a bidirectional map.
    /// - Parameter transform: Bidirectional mapper used to adapt the input.
    /// - Returns: New bi-directional closure.
    public func pullback<T>(
        _ transform: @autoclosure () -> BidirectionalMap<T, Input, Failure>
    ) -> BidirectionalMap<T, Output, Failure> {
        let mapper = transform()
        return pullback(mapper.forward, reverse: mapper.reverse)
    }
}
