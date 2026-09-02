//
//  ZipOptional.swift
//  Minimal
//
//  Created by Martônio Júnior on 20/07/2026.
//

public protocol ZipOptional {
    associatedtype Wrapped

    var optional: Wrapped? { get }
}

// MARK: Optional (EX)
extension Optional: ZipOptional {
    public var optional: Wrapped? { self }
}

// MARK: Tuple (EX)
@available(macOS 14, *)
public extension Tuple where repeat each Element: ZipOptional {
    /// Bubbles up all optional to make the tuple itself optional.
    var zipOptional: Tuple<repeat (each Element).Wrapped>? {
        var elements = [Any]()

        for element in repeat each values {
            guard let element = element.optional else { return nil }

            elements.append(element)
        }

        return try? Tuple<repeat (each Element).Wrapped>(sequence: elements)
    }
}

@available(macOS 14, *)
public extension Tuple {
    /// Transforms each value of the tuple.
    /// - Parameter transform: Transformations applied to each element
    /// - Throws: `E` when mapping fails with a value.
    /// - Returns: Tuple with the new values
    func compactMap<each T: ZipOptional, E>(
        _ transforms: repeat (each Element) throws(E) -> each T
    ) throws(E) -> Tuple<repeat each T>? {
        var elements = [Any]()

        for (element, transform) in repeat (each values, each transforms) {
            guard let result = try transform(element).optional else { return nil }

            elements.append(result)
        }

        return try? Tuple<repeat each T>(sequence: elements)
    }
}

// MARK: Global (EX)
/// Groups together multiple optional values into a tuple.
/// - Parameter optionals: Group of optionals.
/// - Returns: Tuple with unwrapped values, `nil` when any of them is a `nil`.
@available(macOS 14.0.0, *)
public func zipOptional<each T: ZipOptional>(_ optionals: repeat each T) -> (repeat (each T).Wrapped)? {
    Tuple(repeat each optionals).zipOptional?.values
}
