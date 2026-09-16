//
//  ForwardApplication+Tests.swift
//  Minimal
//
//  Created by Martônio Júnior on 15/09/2026.
//

@testable import Operators
import Testing

struct ForwardApplicationTests {
    @Test("Applies a value to a closure", arguments: [
        (5, false)
    ])
    func forwardPipe(_ lhs: Int, expected: Bool) {
        let f = { (x: Int) in x > 10 }
        let result = lhs |> f
        #expect(result == expected)
    }

    @Test("Purifies a mutating function", arguments: [
        (5, 6)
    ])
    func purify(_ input: Int, expected: Int) {
        let f1: (inout Int) -> Void = { $0 += 1 }
        let g1 = f1<|
        let h1 = f1 <| input
        #expect(g1(input) == expected)
        #expect(h1 == expected)

        let f2: (inout Int) -> Bool = { $0 += 1; return true }
        let g2 = f2<|
        let h2 = f2 <| input
        #expect(g2(input) == (expected, true))
        #expect(h2 == (expected, true))
    }

    @Test("Pipes a value using a mutation", arguments: [
        (5, 6)
    ])
    func forwardMutation(_ input: Int, expected: Int) {
        let f1: (inout Int) -> Void = { $0 += 1 }
        let g1 = input &> f1
        #expect(g1 == expected)

        class Wrap {
            var value: Int

            init(_ value: Int) {
                self.value = value
            }

            deinit {}
        }

        let f2: (Wrap) -> Void = { $0.value += 1 }
        let g2 = Wrap(input) &> f2
        #expect(g2.value == expected)
    }

    @Test("Transforms a pure function into a mutating one", arguments: [
        (2, 4)
    ])
    func mutating(_ input: Int, expected: Int) {
        let f1: (Int) -> Int = { $0 * 2 }
        let g1 = f1<&
        var a11 = input
        var a12 = input
        f1 <& a11
        g1(&a12)

        #expect(a11 == expected)
        #expect(a12 == expected)

        let f2: (Int) -> (Int, Bool) = { ($0 * 2, false) }
        let g2 = f2<&
        var a21 = input
        var a22 = input
        let result1 = f2 <& a21
        let result2 = g2(&a22)

        #expect(a21 == expected)
        #expect(result1 == false)
        #expect(a22 == expected)
        #expect(result2 == false)
    }

    @Test("Swaps value between variables")
    func swap() {
        var a = 2
        var b = 8
        a <&> b
        #expect(a == 8)
        #expect(b == 2)
    }

    @Test("Turns the function into an optional of itself")
    func optionalize() {
        let f: (Int, String) -> Bool = { $0 == 0 && !$1.isEmpty }
        let g = f<?

        #expect(g(0, "goal") == true)
        #expect(g(nil, "goal") == nil)
        #expect(g(0, nil) == nil)
        #expect(g(nil, nil) == nil)
    }
}
