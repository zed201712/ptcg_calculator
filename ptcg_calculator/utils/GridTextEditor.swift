//
//  GridTextEditor.swift
//  ptcg_calculator
//
//  Created by Yuu on 2025/1/2.
//

import Foundation
//Example

//let lines = """
//1\t2\t3
//1\t2\t3
//"""
//
//let editor = GridTextEditor()
//print(editor.edit(lines) {index, readOnlyGrid, grid in
//    let txt = readOnlyGrid.getText(index)
//    let y = index.y
//    //let x = index.x
//    guard let value = UInt32(txt) else {return}
//    if y % 2 == 0 {
//        let newWord = String(UnicodeScalar("A".unicodeScalars.first!.value + value - 1)!)
//        grid.setText(index, newWord)
//    }
//})

extension [[String]] {
    static func testGetGridArray() {
        let testArray = [
            ["1","2","3"],
            ["7","8"],
            ["9"],
        ]
        
        assert(
            testArray.getGridArray() == [
                ["1","2","3"],
                ["7","8",""],
                ["9","",""],
            ]
        )
        
        
        assert(
            testArray.getGridArray(isRotate: true) == [
                ["1","7","9"],
                ["2","8",""],
                ["3","",""],
            ]
        )
        
        
        let testArray2 = [
            ["1","2","3"],
            ["7","8", "9"],
            ["0"],
        ]
        
        assert(
            testArray2.getGridArray() == [
                ["1","2","3"],
                ["7","8","9"],
                ["0","",""],
            ]
        )
        
        
        assert(
            testArray2.getGridArray(isRotate: true) == [
                ["1","7","0"],
                ["2","8",""],
                ["3","9",""],
            ]
        )
        
        
        let testArray3 = [
            ["1","2","3"],
            ["7","8"],
        ]
        
        assert(
            testArray3.getGridArray() == [
                ["1","2","3"],
                ["7","8",""],
            ]
        )
        
        
        assert(
            testArray3.getGridArray(isRotate: true) == [
                ["1","7"],
                ["2","8"],
                ["3",""],
            ]
        )
    }
    func maxX() -> Int {
        self.map({$0.count}).max() ?? 0
    }
    func maxY() -> Int {
        self.count
    }
    func getGridElement(x: Int, y: Int) -> Self.Element.Element? {
        self[safe: y]?[safe: x]
    }
    
    func getGridArray(isRotate: Bool = false) -> [[String]] {
        var result = [[String]]()
        let yCount = maxY()
        let xCount = maxX()
        for _ in 0..<yCount {
            result.append(Array<String>(repeating: "", count: xCount))
        }
        for y in 0..<yCount {
            for x in 0..<xCount {
                if let element = getGridElement(x: x, y: y) {
                    result[y][x] = element
                }
            }
        }
        
        guard isRotate else {return result}
        var rotateResult = [[String]]()
        for _ in 0..<xCount {
            rotateResult.append(Array<String>(repeating: "", count: yCount))
        }
        for y in 0..<yCount {
            for x in 0..<xCount {
                rotateResult[x][y] = result[y][x]
            }
        }
        
        return rotateResult
    }
    
    func printOutput() -> String {
        let grid = self.getGridArray(isRotate: true)
        return grid.reduce("", {$0 + "\n" + $1.joined(separator: "\n")})
    }
    
    func matterMostOutput() -> String {
        guard let firstLine = self.first else {return ""}
        var result = ""
        
        func newLine() {
            result += " |"
            result += "\n"
        }
        func input(_ line: [String]) {
            result += ("| " + line.joined(separator: " | "))
            newLine()
        }
        
        input(firstLine)
        
        result += ([String](repeating: "| --- ", count: maxX()).joined()) + "|\n"
        
        for line in self.dropFirst() {
            input(line)
        }
        
        return result
    }
}

struct GridTextEditor {
    var lineSeparator: String = "\n"
    var wordSeparator: String = "\t"
    
    struct Grid {
        fileprivate var data: [[String]]
        func getText(_ index: Index) -> String {
            data[index.y][index.x]
        }
        mutating func setText(_ index: Index, _ text: String) {
            data[index.y][index.x] = text
        }
    }
    struct Index {
        var x: Int
        var y: Int
    }
    
    func edit(_ linesText: String, editFunction: (Index, Grid, inout Grid) -> Void) -> String {
        let lines = linesText.components(separatedBy: lineSeparator)
        let grid = lines.map{$0.components(separatedBy: wordSeparator)}
        let readOnlyGrid = Grid.init(data: grid)
        var currentGrid = readOnlyGrid
        for y in 0 ..< grid.count {
            for x in 0 ..< grid[y].count {
                editFunction(.init(x: x, y: y), readOnlyGrid, &currentGrid)
            }
        }
        return (currentGrid.data.map{$0.joined(separator: wordSeparator)}).joined(separator: lineSeparator)
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Hashable {
    func removeDuplicates() -> [Element] {
        var seen = Set<Element>()
        return self.filter({ element in
            if seen.contains(element) {
                return false
            } else {
                seen.insert(element)
                return true
            }
        })
    }
    
    static func testRemoveDuplicates() {
        // 測試用例 1：一般情況
        let input1 = ["A", "B", "B", "C"]
        let expected1 = ["A", "B", "C"]
        assert(input1.removeDuplicates() == expected1)
        
        // 測試用例 2：全部元素相同
        let input2 = ["A", "A", "A", "A"]
        let expected2 = ["A"]
        assert(input2.removeDuplicates() == expected2)
        
        // 測試用例 3：無重複元素
        let input3 = ["A", "B", "C"]
        let expected3 = ["A", "B", "C"]
        assert(input3.removeDuplicates() == expected3)
        
        // 測試用例 4：空陣列
        let input4: [String] = []
        let expected4: [String] = []
        assert(input4.removeDuplicates() == expected4)
        
        // 測試用例 5：含有空字串
        let input5 = ["", "A", "", "B"]
        let expected5 = ["", "A", "B"]
        assert(input5.removeDuplicates() == expected5)
        
        // 測試用例 6：不同大小寫應視為不同元素
        let input6 = ["a", "A", "a", "A"]
        let expected6 = ["a", "A"]
        assert(input6.removeDuplicates() == expected6)
    }
}
