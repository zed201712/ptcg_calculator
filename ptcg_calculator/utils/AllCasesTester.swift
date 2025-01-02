//
//  AllCasesTester.swift
//  ptcg_calculator
//
//  Created by Yuu on 2025/1/2.
//

import Foundation

class AllCasesTester {
    static func testAll() {
        testCreateRadixNumber()
        testCreateBinary()
        testCreateBinaryArray()
        testCreateAllPathArray()
    }
    
    static func createRadixNumber(_ input: Int, radix: Int = 2, digits: Int? = nil) -> String {
        guard input >= 0, radix >= 2 else {return ""}
        let numberText = String(input, radix: radix)
        let digits = digits ?? numberText.count
        let zeroCount = max(digits - numberText.count, 0)
        return Array(repeating: "0", count: zeroCount) + numberText
    }
    private static func testCreateRadixNumber() {
        assert(createRadixNumber(0) == "0")
        assert(createRadixNumber(1) == "1")
        assert(createRadixNumber(2) == "10")
        assert(createRadixNumber(0, radix: 2) == "0")
        assert(createRadixNumber(1, radix: 2) == "1")
        assert(createRadixNumber(2, radix: 2) == "10")
        assert(createRadixNumber(0, radix: 2, digits: 2) == "00")
        assert(createRadixNumber(1, radix: 2, digits: 2) == "01")
        assert(createRadixNumber(2, radix: 2, digits: 2) == "10")
        
        assert(createRadixNumber(0, radix: 3) == "0")
        assert(createRadixNumber(1, radix: 3) == "1")
        assert(createRadixNumber(2, radix: 3) == "2")
        assert(createRadixNumber(3, radix: 3) == "10")
        assert(createRadixNumber(4, radix: 3) == "11")
        assert(createRadixNumber(5, radix: 3) == "12")
        assert(createRadixNumber(0, radix: 3, digits: 3) == "000")
        assert(createRadixNumber(1, radix: 3, digits: 3) == "001")
        assert(createRadixNumber(2, radix: 3, digits: 3) == "002")
        assert(createRadixNumber(3, radix: 3, digits: 3) == "010")
        assert(createRadixNumber(4, radix: 3, digits: 3) == "011")
        assert(createRadixNumber(5, radix: 3, digits: 3) == "012")
    }
    
    static func createBinary(_ input: Int, digits: Int? = nil) -> [Bool] {
        guard input >= 0 else {return []}
        let binaryString = createRadixNumber(input, radix: 2, digits: digits)
        let array = binaryString.map({$0 == "1"})
        return array
    }
    private static func testCreateBinary() {
        assert(createBinary(0) == [false])
        assert(createBinary(1) == [true])
        assert(createBinary(2) == [true, false])
        assert(createBinary(0, digits: 2) == [false, false])
        assert(createBinary(1, digits: 2) == [false, true])
        assert(createBinary(2, digits: 2) == [true, false])
    }
    
    static func createBinaryArray(_ max: Int) -> [[Bool]] {
        guard max > 0 else {return []}
        
        let digits = String(max - 1, radix: 2).count
        
        return (0..<max).map({createBinary($0, digits: digits)})
    }
    private static func testCreateBinaryArray() {
        assert(createBinaryArray(1) == [
            [false]
        ])
        assert(createBinaryArray(2) == [
            [false], [true]
        ])
        assert(createBinaryArray(3) == [
            [false, false], [false, true], [true, false]
        ])
        assert(createBinaryArray(4) == [
            [false, false], [false, true], [true, false], [true, true]
        ])
        assert(createBinaryArray(5) == [
            [false, false, false], [false, false, true], [false, true, false], [false, true, true], [true, false, false]
        ])
    }
    
    static func createAllPathArray(_ max: Int) -> [[Int]] {
        guard max > 0 else { return [] }
        let numbers = Array(0..<max)
        return permutations(of: numbers)
    }
    static func permutations<T>(of array: [T]) -> [[T]] {
        guard array.count > 1 else { return [array] }
        
        var result: [[T]] = []
        for (index, element) in array.enumerated() {
            var remaining = array
            remaining.remove(at: index)
            let subPermutations = permutations(of: remaining)
            result += subPermutations.map { [element] + $0 }
        }
        return result
    }
    private static func testCreateAllPathArray() {
        assert(createAllPathArray(1) == [[0]])
        assert(createAllPathArray(2) == [
            [0, 1],
            [1, 0],
        ])
        assert(createAllPathArray(3) == [
            [0, 1, 2],
            [0, 2, 1],
            [1, 0, 2],
            [1, 2, 0],
            [2, 0, 1],
            [2, 1, 0],
        ])
    }
}
