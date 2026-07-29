//
//  Sequence+Either.swift
//  Minimal
//
//  Created by Martônio Júnior on 29/07/2026.
//

public extension Sequence {
    /// Splits the values stored based on it's side on an `Either` expression.
    /// - Parameter transform: Map to transform the elements into `Either`.
    /// - Returns: Tuple with left-side and right-side elements split accordingly into respective arrays.
    func partition<Left, Right>(_ transform: (Element) -> Either<Left, Right>) -> (left: [Left], right: [Right]) {
        self.reduce(into: (left: [], right: [])) { result, element in
            transform(element).match {
                result.left.append($0)
            } or: {
                result.right.append($0)
            }
        }
    }
}
