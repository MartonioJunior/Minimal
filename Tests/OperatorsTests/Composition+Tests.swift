//
//  Composition+Tests.swift
//  Minimal
//
//  Created by Martônio Júnior on 20/07/2026.
//

@testable import Operators
import Testing
import Tuple

struct CompositionTests {
    @Test("Composes two functions together")
    func compose() {
        let f1: (Int) -> Bool = { _ in true }
        let g1: (Bool, String) -> Double = { _, _ in 1.0 }
        let h1 = f1 >>> g1
        let i1 = g1 <<< f1
        #expect(h1(22, "yes") == 1.0)
        #expect(i1(22, "yes") == 1.0)

        let f2: (Int, Double) -> (Bool, String) = { _, _ in (true, "goal") }
        let g2: (Bool, String) -> Double = { _, _ in 4.0 }
        let h2 = f2 >>> g2
        let i2 = g2 <<< f2
        #expect(h2(1, 2.5) == 4.0)
        #expect(i2(1, 2.5) == 4.0)

        let f3 = { 12 }
        let g3: (Int) -> Bool = { _ in true }
        let h3 = f3 >>> g3
        let i3 = g3 <<< f3
        #expect(h3() == true)
        #expect(i3() == true)
    }

    @Test("Curries a function")
    func curry() {
        let f: (Int, Bool, String) -> Double = { _, _, _ in 4 }
        let f2 = f>>>
        let f3 = f2>>>
        let f4 = f3>>>
        #expect(f4()(12)(false)("goal") == 4)

        let g = 14>>>
        #expect(g() == 14)
    }

    @Test("Curries a value in reverse order", arguments: [
        (5, false, 3.2)
    ])
    func inverseCurryOperator(_ a: Int, _ b: Bool, _ c: Double) {
        let f: (Int, Bool, Double) -> String = { "\($0),\($1),\($2)" }
        let g = inverseCurry(f)

        #expect(f(a, b, c) == g(b, c)(a))
    }

    @Test("Uncurries a function")
    func uncurry() {
        let f: () -> (Int) -> (Bool, Int) -> (String) -> Double = { { _ in { _, _ in { _ in 7 } } } }
        let f2 = f<<<
        let f3 = f2<<<
        let f4 = f3<<<
        #expect(f4((2, false, 7), "yes") == 7)
    }

    @Test("Uncurries a function in reverse order")
    func inverseUncurryOperator() {
        let f: (Int, Bool) -> (String) -> Double = { _, _ in { _ in 15 }}
        let g = inverseUncurry(f)
        #expect(f(2, true)("x") == g("x", 2, true))

        let h: (Int) -> (Bool, String) -> Double = { _ in { _, _ in 1.0 } }
        let i = inverseUncurry(h)
        #expect(h(1)(false, "yes") == i(false, 1)("yes"))
    }

    @Test("Chains optionals together", arguments: [
        (2, 5, 7),
        (6, 5, 11),
        (11, 5, Int?.none)
    ])
    func kleisli_optional(_ a: Int, _ b: Int, expected: Int?) {
        let f: (Int, Int) -> Int? = { ($0 > 10) ? nil : $0 + $1 }
        let g: (Int) -> Int = \.self
        let h = f >=> g
        let i = g <=< f

        #expect(h(a, b) == expected)
        #expect(i(a, b) == expected)
    }

    @Test("Chains sequences together", arguments: [
        (1, 2, [true, true, true])
    ])
    func kleisli_sequence(_ a: Int, _ b: Int, expected: [Bool]) {
        let f: (Int, Int) -> [Int] = { [$0, $1] }
        let g: (Int) -> Repeated<Bool> = { repeatElement(true, count: $0) }
        let h = f >=> g
        let i = g <=< f

        #expect(h(a, b) == expected)
        #expect(i(a, b) == expected)
    }

    @Test("Creates a setter from a key path")
    func setter() {
        struct Example: Equatable { var target: Int }
        let keyPath = \Example.target
        let fixedSet = keyPath >&> 8
        var example = Example(target: 3)
        fixedSet(&example)
        #expect(example == Example(target: 8))

        let f1: (Int, Int) -> Int = { $0 + $1 }
        let setWithExtras = keyPath >&> f1
        var a1 = Example(target: 3)
        setWithExtras(&a1, 4, 7)
        #expect(a1 == Example(target: 11))

        let f2: (inout Int) -> Bool = { $0 += 1; return true }
        let mutatingSet = keyPath >&> f2
        var a2 = Example(target: 4)
        let result = mutatingSet(&a2)
        #expect(a2 == Example(target: 5))
        #expect(result == true)

        let f3: (Int) -> Int = { $0 * 2 }
        let pureSet = keyPath >&> f3
        var a3 = Example(target: 2)
        pureSet(&a3)
        #expect(a3 == Example(target: 4))
    }

    @Test("Flips a function around", arguments: [
        (2, 3, false, 4.5)
    ])
    func flip(_ a: Int, _ b: Int, _ c: Bool, _ d: Double) {
        let f: (Int, Int) -> (Bool, Double) -> String = { _, _ in
            { _, _ in "\(a),\(b),\(c),\(d)" }
        }
        let g = f<!
        #expect(f(a, b)(c, d) == g(c, d)(a, b))
    }
}
