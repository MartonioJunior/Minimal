//
//  Tuple.swift
//  Minimal
//
//  Created by Martônio Júnior on 16/08/2025.
//

import Builtin
import Global

/// Group of heterogeneous values defined by variadic generics that can be stored together.
/// 
/// Example:
/// ```swift
/// let tuple = Tuple(24, "goal", 14.5)
/// ```
@dynamicMemberLookup
@available(macOS 14, iOS 17, *)
public struct Tuple<each Element> {
    // MARK: Variables
    /// Internal tuple used for storage.
    public var values: (repeat each Element)
    /// Heterogeneous array representing the tuple.
    /// 
    /// Used by the type to perform index-based operations when necessary.
    var array: [Any] {
        var result = [Any]()
        for element in repeat each values {
            result.append(element)
        }
        return result
    }
    /// Number of elements in the tuple.
    var count: Int { Int(Builtin.packLength((repeat each Element).self)) }
    /// Subscript that allows direct access to a tuple's elements.
    /// - Parameter keyPath: Key Path to the desired element.
    /// - Returns: Desired element.
    public subscript<T>(dynamicMember keyPath: KeyPath<(repeat each Element), T>) -> T {
        values[keyPath: keyPath]
    }
    /// Subscript that allows direct access to a tuple's elements.
    /// - Parameter keyPath: Key Path to the desired element.
    /// - Returns: Desired element.
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<(repeat each Element), T>) -> T {
        get { values[keyPath: keyPath] }
        set { values[keyPath: keyPath] = newValue }
    }
    // MARK: Initializers
    /// Creates a tuple from a group of heterogeneous values.
    /// - Parameter elements: Group of heterogeneous values.
    public init(_ elements: repeat each Element) {
        self.values = (repeat each elements)
    }
    /// Creates a tuple directly from a heterogenous sequence.
    /// - Parameter sequence: Heterogeneous sequence.
    /// 
    /// This initializer does not perform any type or size checks,
    /// so it should only be used to provide instant initialization with sequences.
    public init(sequence: some Sequence<Any>) throws {
        var iterator = sequence.makeIterator()
        values = try (repeat { _ in try cast(iterator.next()) }((each Element).self))
    }
    /// Creates a tuple by unpacking an existing one.
    /// - Parameter rawTuple: Tuple.
    public init(unpacking rawTuple: (repeat each Element)) {
        values = rawTuple
    }
    // MARK: Methods
    /// Transforms each value of the tuple.
    /// - Parameter transform: Transformations applied to each element
    /// - Throws: `E` when mapping fails with a value.
    /// - Returns: Tuple with the new values
    func map<each T, E: Error>(
        _ transforms: repeat (each Element) throws(E) -> each T
    ) throws(E) -> Tuple<repeat each T> {
        .init(repeat try (each transforms)(each values))
    }
    /// Combines this tuple's elements into a single value.
    /// - Parameter transform: Transformation applied to the tuple.
    /// - Throws: `E` when mapping fails with a value.
    /// - Returns: Value transformed from the tuple.
    public func match<T, E: Error>(_ transform: (repeat each Element) throws(E) -> T) throws(E) -> T {
        try transform(repeat each values)
    }
    /// Inserts a group of new values to the start of the tuple.
    /// - Parameter elements: Group of heterogeneous values.
    /// - Returns: Tuple with old and new values.
    public func prefixed<each T>(by elements: repeat each T) -> Tuple<repeat each T, repeat each Element> {
        .init(repeat each elements, repeat each values)
    }
    /// Appends a group of new values to the end of the tuple.
    /// - Parameter elements: Group of heterogeneous values.
    /// - Returns: Tuple with old and new values.
    public func suffixed<each T>(by elements: repeat each T) -> Tuple<repeat each Element, repeat each T> {
        .init(repeat each values, repeat each elements)
    }
    /// Combines this tuple's elements with another tuple of the same size.
    /// - Parameter other: Tuple to combine with.
    /// - Returns: New tuple with the paired elements as a tuple.
    public func zip<each T>(with other: Tuple<repeat each T>) -> Tuple<repeat (each Element, each T)> {
        .init(repeat (each values, each other.values))
    }
}

// MARK: DotSyntax
@available(macOS 14, iOS 17, *)
public extension Tuple {
    /// Function that transforms values into a `Tuple`.
    static var ify: (repeat each Element) -> Self {
        { (args: repeat each Element) in .init(repeat each args) }
    }
    /// Number of elements in the tuple.
    static var packCount: Int { Int(Builtin.packLength((repeat each Element).self)) }
    /// Creates a tuple from an heterogeneous sequence.
    /// - Parameter sequence: Heterogeneous sequence.
    /// - Returns: Tuple composed by the sequence. 
    static func from(_ sequence: some Sequence<Any>) -> Self? {
        guard let tuple = try? Self.raw(from: sequence) else { return nil }

        return .init(repeat each tuple)
    }
    /// Creates a tuple from an heterogeneous sequence.
    /// - Parameter sequence: Heterogeneous sequence.
    /// - Returns: Tuple composed by the sequence, returning `nil` optionals wherever casting was not possible. 
    static func raw(from sequence: some Sequence<Any>) throws -> (repeat each Element) {
        var iterator = sequence.makeIterator()
        return try (repeat { _ in try cast(iterator.next()) }((each Element).self))
    }
    /// Creates a tuple from an heterogeneous sequence.
    /// - Parameter sequence: Heterogeneous sequence.
    /// - Returns: Tuple composed by the sequence.
    static func rawOptional(from sequence: some Sequence<Any>) -> (repeat Optional<each Element>) {
        var iterator = sequence.makeIterator()
        return (repeat iterator.next() as? each Element)
    }
}

// MARK: Self.AllTypes
@available(macOS 14, iOS 17, *)
public extension Tuple {
    /// Type representing a tuple of all types that define this one.
    typealias AllTypes = Tuple<repeat (each Element).Type>
    /// Tuple containing all types that define this one.
    static var allTypes: AllTypes { .init(repeat (each Element).self) }
}

// MARK: Self: BitwiseCopyable
@available(macOS 14, iOS 17, *)
extension Tuple: BitwiseCopyable where repeat each Element: BitwiseCopyable {}

// MARK: Self: Comparable
@available(macOS 14, iOS 17, *)
extension Tuple: Comparable where repeat each Element: Comparable {
    // swiftlint:disable:next missing_docs
	public static func < (lhs: Self, rhs: Self) -> Bool {
		for (lhs, rhs) in repeat (each lhs.values, each rhs.values) {
			guard lhs == rhs else { return lhs < rhs }
		}
		return false
	}
}

// MARK: Self: CustomStringConvertible
@available(macOS 14, iOS 17, *)
extension Tuple: CustomStringConvertible where repeat each Element: CustomStringConvertible {
    // swiftlint:disable:next missing_docs
    public var description: String {
        var components: [String] = []
        for element in repeat (each values).description {
            components.append(element)
        }
        return "(\(components.joined(separator: ", ")))"
    }
}

// MARK: Self: Decodable
@available(macOS 14.0.0, *)
extension Tuple: Decodable where repeat each Element: Decodable {
    // swiftlint:disable:next missing_docs
	public init(from decoder: any Decoder) throws {
		var container = try decoder.unkeyedContainer()
		values = (repeat try container.decode((each Element).self))
	}
}

// MARK: Self: Encodable
@available(macOS 14.0.0, *)
extension Tuple: Encodable where repeat each Element: Encodable {
    // swiftlint:disable:next missing_docs
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.unkeyedContainer()
		repeat try container.encode((each values).self)
	}
}

// MARK: Self: Equatable
@available(macOS 14.0.0, *)
extension Tuple: Equatable where repeat each Element: Equatable {
    // swiftlint:disable:next missing_docs
    public static func == (lhs: Self, rhs: Self) -> Bool {
        for (lhs, rhs) in repeat (each lhs.values, each rhs.values) {
			guard lhs == rhs else { return false }
		}

		return true
    }
}

// MARK: Self: Error
@available(macOS 14.0.0, *)
extension Tuple: Error where repeat each Element: Error {}

// MARK: Self: Hashable
@available(macOS 14, iOS 17, *)
extension Tuple: Hashable where repeat each Element: Hashable {
    // swiftlint:disable:next missing_docs
	public func hash(into hasher: inout Hasher) {
		for element in repeat each values {
			hasher.combine(element)
		}
	}
}

// MARK: Self: Sendable
@available(macOS 14.0.0, *)
extension Tuple: Sendable where repeat each Element: Sendable {}
