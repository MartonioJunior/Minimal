//
//  ZipSequence.swift
//  Minimal
//
//  Created by Martônio Júnior on 20/07/2026.
//

/// Data structure representing a zip of multiple sequences of different types.
@available(macOS 14.0.0, *)
public struct ZipSequence<each S: Sequence> {
    /// Sequences that compose this zip sequence.
    let values: (repeat each S)
    /// Creates a zip sequence.
    /// - Parameter values: Sequences that compose this zip sequence.
    public init(_ values: repeat each S) {
        self.values = (repeat each values)
    }
}

// MARK: Self.Iterator
@available(macOS 14.0.0, *)
public extension ZipSequence {
    // swiftlint:disable:next missing_docs
    struct Iterator {
        /// Tuple containing all of the iterators.
        var iterators: Tuple<repeat (each S).Iterator>
        /// Flag indicating when the iteration has reached it's end.
        /// 
        /// This happens when one of the iterators ends iteration.
        var reachedEnd: Bool = false
        /// Creates a new iterator.
        /// - Parameter iterators: List of all iterators.
        init(_ iterators: repeat (each S).Iterator) {
            self.iterators = Tuple(repeat each iterators)
        }
    }
}

@available(macOS 14.0.0, *)
extension ZipSequence.Iterator: IteratorProtocol {
    // swiftlint:disable:next missing_docs
    public typealias Element = Tuple<repeat (each S).Element>
    // swiftlint:disable:next missing_docs
    public mutating func next() -> Element? {
        if reachedEnd { return nil }

        var elements = [Any]()
        var transformers = iterators.array.map { $0 as? any IteratorProtocol }

        for i in transformers.indices {
            let value = transformers[i]?.next() as Any
            elements.append(value)
        }

        iterators.values = try! Tuple<repeat (each S).Iterator>.raw(from: transformers.map { $0 as Any })

        guard let result = try? Tuple<repeat (each S).Element>(sequence: elements) else {
            reachedEnd = true
            return nil
        }

        return result
    }
}

// MARK: Self: Sequence
@available(macOS 14.0.0, *)
extension ZipSequence: Sequence {
    // swiftlint:disable:next missing_docs
    public func makeIterator() -> Iterator {
        Iterator(repeat (each values).makeIterator())
    }
}

// MARK: Tuple (EX)
@available(macOS 14.0.0, *)
public extension Tuple where repeat each Element: Sequence {
    /// Creates a zip sequence out of the tuple's elements.
    var zipSequence: ZipSequence<repeat each Element> {
        .init(repeat each values)
    }
    /// Performs a mapping as a zip sequence.
    /// - Parameter transform: Transformation function.
    /// - Returns: Array of the resulting values.
    func zipMap<T>(_ transform: (Tuple<repeat (each Element).Element>) -> T) -> [T] {
        var result: [T] = []
        for element in zipSequence {
            result.append(transform(element))
        }
        return result
    }
}

// MARK: Global
/// Zips multiple sequences together into a transformation.
/// - Parameters:
///   - sequences: List of sequences to combine together
///   - transform: Transformation function for each tuple generated.
/// - Returns: List of transformed values.
@available(macOS 14.0.0, *)
public func zipSequence<each S: Sequence, T>(
    _ sequences: repeat each S,
    with transform: (repeat (each S).Element) -> T
) -> [T] {
    Tuple(repeat each sequences).zipMap {
        transform(repeat each $0.values)
    }
}
