//
//  BidirectionalMap+Tests.swift
//  Minimal
//
//  Created by Martônio Júnior on 23/08/2026.
//

@testable import Bidirectional
import Testing

struct BidirectionalMapTests {
    @Test("Creates a new bi-directional closure")
    func initializer() {
        let sut = BidirectionalMap<Int, Int, Never> {
            $0 + 4
        } reverse: {
            $0 - 4
        }

        #expect(sut.forward(10) == 14)
        #expect(sut.reverse(14) == 10)
    }

    @Test("Returns an inverted bidirectional function")
    func swapped() {
        let sut = BidirectionalMap<Int, Int, Never> {
            $0 * 2
        } reverse: {
            $0 / 2
        }

        let result = sut.swapped
        #expect(result.forward(12) == 6)
        #expect(result.reverse(6) == 12)
    }

    @Test("Maps the function to a new output")
    func map() {
        let sut = BidirectionalMap<Int, Int, Never> {
            $0 - 3
        } reverse: {
            $0 + 3
        }

        let result = sut.map {
            $0 * 4
        } reverse: {
            $0 / 4
        }

        #expect(result.forward(6) == 12)
        #expect(result.reverse(12) == 6)
    }

    @Test("Maps the function to a new input")
    func pullback() {
        let sut = BidirectionalMap<Int, Int, Never> {
            $0 - 3
        } reverse: {
            $0 + 3
        }

        let result = sut.pullback {
            $0 * 4
        } reverse: {
            $0 / 4
        }
    }
}
