//
//  RoundStatistics.swift
//  ptcg_calculator
//
//  Created by Yuu on 2025/1/11.
//

import Foundation

class 回合統計表: MyCodable {
    typealias 統計資料類型 = [[Int]]
    
    enum 顯示類型 {
        case JSON
        case 標準
        case 表格
    }
    
    private var 目前x軸: Int = 0
    private(set) var 名稱 = ""
    private var x軸範圍 = 1...2
    private var 測試次數整數 = 0
    private var 測試次數 = Double(0)
    private var 達成次數: 統計資料類型 = []
    
    init() {}
    
    static func 執行所有測試() {
        回合統計表.測試嚴格合併()
        回合統計表.測試差距次數()
        回合統計表.測試左右項差距次數()
        回合統計表.測試修改測試次數()
        回合統計表.測試製表()
        回合統計表.測試合併()
    }
    
    static func 合併(_ array: [回合統計表]) -> [回合統計表] {
        var 未合併統計表 = array.map({ 複製資料($0) })
        var 所有統計表: [回合統計表] = []
        while var 新統計表 = 未合併統計表.first {
            未合併統計表 = Array(未合併統計表.dropFirst())
            for i in (0 ..< 未合併統計表.count).reversed() {
                if 可嚴格合併(新統計表, 未合併統計表[i]) {
                    新統計表 = 嚴格合併([ 新統計表, 未合併統計表[i] ])
                    未合併統計表.remove(at: i)
                }
            }
            所有統計表.append(新統計表)
        }
        
        return 所有統計表
    }
    
    private static func 可嚴格合併(_ 表1: 回合統計表, _ 表2: 回合統計表) -> Bool {
        (表1.名稱 == 表2.名稱)
        && (表1.x軸範圍 == 表2.x軸範圍)
        && (表1.達成次數.count == 表2.達成次數.count)
        && ( (表1.達成次數.first?.count ?? 0) == (表2.達成次數.first?.count ?? 0) )
    }
    
    private static func 嚴格合併(_ array: [回合統計表]) -> 回合統計表 {
        let first = array.first!
        assert(
            array.first(where: {
                可嚴格合併(first, $0) == false
            }) == nil
        )
        
        let result = 回合統計表.複製資料(first)
        result.測試次數整數 = array.reduce(0, {$0 + $1.測試次數整數})
        result.測試次數 = Double(result.測試次數整數)
        
        for rhs in array.dropFirst() {
            result.達成次數 = 回合統計表.疊加(result.達成次數, rhs.達成次數)
        }
        
        return result
    }
    private static func 測試嚴格合併() {
        let table1 = 回合統計表()
        table1.重置(100, 名稱: "table", 範圍: 1...3, 回合數上限: 2)
        table1.達成次數 = [
            [1,3,5],
            [0,1,2],
        ]
        let table2 = 回合統計表()
        table2.重置(50, 名稱: "table", 範圍: 1...3, 回合數上限: 2)
        table2.達成次數 = [
            [9,8,7],
            [3,6,9],
        ]
        
        let newTable = 回合統計表.嚴格合併([table1, table2])
        assert(
            newTable.達成次數 == [
                [10,11,12],
                [3,7,11],
            ]
        )
        assert( newTable.測試次數整數 == 150 )
    }
    
    static func 複製資料(_ 統計表: 回合統計表) -> 回合統計表 {
        回合統計表(data: 統計表.jsonData!)!
    }
    
    func 重置牌組計算範圍(_ 玩家: 寶可夢玩家, 最低 最低雜牌基礎寶可夢數量: Int) -> ClosedRange<Int> {
        玩家.重置牌組(玩家.預設牌組())
        玩家.重置()
        let 雜牌數量 = 玩家.抽牌堆.filter({$0.是雜牌()}).count
        let 最低雜牌基礎寶可夢數量 = min(max(最低雜牌基礎寶可夢數量, 0), 雜牌數量)
        let 雜牌基礎寶可夢數量範圍 = 最低雜牌基礎寶可夢數量 ... 雜牌數量
        
        return 雜牌基礎寶可夢數量範圍
    }
    
    func 重置(_ 測試次數: Int, 名稱: String = "", 範圍 x軸範圍: ClosedRange<Int>, 回合數上限: Int) {
        self.測試次數整數 = 測試次數
        self.測試次數 = Double(測試次數)
        self.x軸範圍 = x軸範圍
        self.名稱 = 名稱
        
        let empty: [Int] = Array(repeating: 0, count: 回合數上限 + 1)
        達成次數 = Array(repeating: empty, count: x軸範圍.count)
    }
    
    func 設定(數量 目前雜牌基礎寶可夢數量: Int) {
        self.目前x軸 = 目前雜牌基礎寶可夢數量
    }
    
    func 加次數(_ 回合: Int, 次數: Int = 1) {
        達成次數[目前x軸 - x軸範圍.lowerBound][回合] += 次數
    }
    
    func 左右項差距次數() -> 回合統計表 {
        let result = 回合統計表.複製資料(self)
        
        let 第一項 = result.達成次數.first!
        let 回合範圍 = (0 ..< 第一項.count)
        var 達成次數 = result.達成次數
        
        for 回合 in 回合範圍 {
            for x in (1 ..< 達成次數.count).reversed() {
                達成次數[x][回合] = 達成次數[x][回合] - 達成次數[x - 1][回合]
            }
            達成次數[0][回合] = 0//Set baseline to 0
        }
        result.達成次數 = 達成次數
        
        return result
    }
    private static func 測試左右項差距次數() {
        let table1: 回合統計表 = 回合統計表()
        table1.重置(123, 名稱: "table1", 範圍: 2...3, 回合數上限: 2)
        table1.達成次數 = [
            [1,3,5],
            [0,1,2],
        ]
        
        let newTable1 = table1.左右項差距次數()
        assert(
            table1.達成次數 == [
                [1,3,5],
                [0,1,2],
            ]
        )
        assert(
            newTable1.達成次數 == [
                [
                    0,
                    0,
                    0
                ],
                [
                    -1,
                    -2,
                    -3
                ],
            ]
        )
    }
    
    func 修改測試次數(_ 倍數: Int) -> 回合統計表 {
        let result = 回合統計表.複製資料(self)
        guard 倍數 != 1 else { return result }
        
        result.測試次數整數 = result.測試次數整數 * 倍數
        result.測試次數 = Double(result.測試次數整數)
        let 回合範圍 = (0 ..< result.達成次數.first!.count)
        for 回合 in 回合範圍 {
            for x in (0 ..< result.達成次數.count) {
                result.達成次數[x][回合] *= 倍數
            }
        }
        
        return result
    }
    private static func 測試修改測試次數() {
        let table1: 回合統計表 = 回合統計表()
        table1.重置(123, 名稱: "table1", 範圍: 2...3, 回合數上限: 2)
        table1.達成次數 = [
            [1,3,5],
            [0,1,2],
        ]
        
        let newTable1 = table1.修改測試次數(10)
        assert(
            table1.達成次數 == [
                [1,3,5],
                [0,1,2],
            ]
        )
        assert(
            newTable1.達成次數 == [
                [10,30,50],
                [00,10,20],
            ]
        )
    }
    
    func 差距次數(_ 比較對象統計表: 回合統計表) -> 回合統計表 {
        let anotherOne = 回合統計表.複製資料(比較對象統計表)
        
        let result = 回合統計表.複製資料(self)
        result.名稱 = result.名稱 + "_比較_" + 比較對象統計表.名稱
        
        let minX = max(result.x軸範圍.lowerBound, anotherOne.x軸範圍.lowerBound)
        let maxX = min(result.x軸範圍.upperBound, anotherOne.x軸範圍.upperBound)
        
        func 調整X(_ table: 回合統計表) {
            let 前方多餘數量 = minX - table.x軸範圍.lowerBound
            let 後方多餘數量 = table.x軸範圍.upperBound - maxX
            
            table.達成次數 = table.達成次數.dropFirst(前方多餘數量).dropLast(後方多餘數量)
            table.x軸範圍 = minX ... maxX
        }
        
        調整X(result)
        調整X(anotherOne)
        let 回合範圍 = (0 ..< result.達成次數.first!.count)
        for 回合 in 回合範圍 {
            for x in (0 ..< result.達成次數.count) {
                result.達成次數[x][回合] -= anotherOne.達成次數[x][回合]
            }
        }
        
        return result
    }
    private static func 測試差距次數() {
        let table1: 回合統計表 = 回合統計表()
        table1.重置(123, 名稱: "table1", 範圍: 2...3, 回合數上限: 2)
        table1.達成次數 = [
            [1,3,5],
            [0,1,2],
        ]
        let table2: 回合統計表 = 回合統計表()
        table2.重置(2, 名稱: "table2", 範圍: 2...2, 回合數上限: 2)
        table2.達成次數 = [
            [9,8,7],
        ]
        let table3: 回合統計表 = 回合統計表()
        table3.重置(3, 名稱: "table3", 範圍: 1...3, 回合數上限: 2)
        table3.達成次數 = [
            [9,8,7],
            [3,6,9],
            [1,2,3],
        ]
        
        let newTable2 = table1.差距次數(table2)
        let newTable3 = table1.差距次數(table3)
        assert(
            table1.達成次數 == [
                [1,3,5],
                [0,1,2],
            ]
        )
        assert(
            newTable2.達成次數 == [
                [-8,-5,-2],
            ]
        )
        assert(
            newTable3.達成次數 == [
                [-2,-3,-4],
                [-1,-1,-1],
            ]
        )
    }
    
    private static func 疊加(_ lhs: 統計資料類型, _ rhs: 統計資料類型) -> 統計資料類型 {
        guard !lhs.isEmpty else { return lhs }
        
        assert( lhs.count == rhs.count )
        assert( lhs.first!.count == lhs.first!.count )
        
        let 回合範圍 = (0 ..< lhs.first!.count)
        var result = lhs
        for x in 0 ..< lhs.count {
            for 回合 in 回合範圍 {
                result[x][回合] += rhs[x][回合]
            }
        }
        
        return result
    }
    
    private static func 加總(_ 達成次數: 統計資料類型) -> 統計資料類型 {
        let 第一項 = 達成次數.first!
        var 達成次數 = 達成次數
        for x in 0 ..< 達成次數.count {
            for 回合 in 1 ..< 第一項.count {
                達成次數[x][回合] += 達成次數[x][回合 - 1]
            }
        }
        return 達成次數
    }
    
    private static func 去尾(_ 達成次數: 統計資料類型, _ 總次數: Int) -> 統計資料類型 {
        let 第一項 = 達成次數.first!
        let 回合範圍 = (0 ..< 第一項.count)
        var 達成次數 = 達成次數
        
        let 全百分百回合 = Array(回合範圍).firstIndex(where: { 回合 in
            (0 ..< 達成次數.count).first(
                where: { x in
                    達成次數[x][回合] < 總次數
                }
            ) == nil
        }) ?? (回合範圍.count - 1)
        for x in 0 ..< 達成次數.count {
            達成次數[x] = Array(達成次數[x].prefix(全百分百回合 + 1))
        }
        return 達成次數
    }
    
    private static func 製表(_ 達成次數: 統計資料類型, _ 小數點位數: Int, _ 測試次數: Double) -> [[String]] {
        func 單項結果(_ 單項資料: [Int], _ 小數點位數: Int) -> [String] {
            單項資料.enumerated().map({ 回合, 次數 in
                let probability = (Double(次數) / 測試次數 * 100).小數點後(小數點位數)
                return "\(probability)"
            })
        }
        
        return 達成次數.map({單項結果($0, 小數點位數)})
    }
    private static func 測試製表() {
        let 達成次數 = [[10, 20, 30], [5, 15, 25]]
        let result1 = 製表(達成次數, 1, 50.0)
        assert(result1 == [["20.0", "40.0", "60.0"], ["10.0", "30.0", "50.0"]])
        
        let table = 回合統計表()
        table.重置(100, 名稱: "測試表", 範圍: 1...3, 回合數上限: 2)
        table.達成次數 = [
            [10, 20, 30],  // 應轉換為: ["10.0", "20.0", "30.0"]
            [40, 50, 60],  // 應轉換為: ["40.0", "50.0", "60.0"]
            [70, 80, 90]   // 應轉換為: ["70.0", "80.0", "90.0"]
        ]
        
        let result2 = 回合統計表.製表(table.達成次數, 1, Double(table.測試次數整數))
        
        // 驗證結果
        assert(
            result2 == [
                ["10.0", "20.0", "30.0"],
                ["40.0", "50.0", "60.0"],
                ["70.0", "80.0", "90.0"]
            ],
            "製表結果不符合預期"
        )
        
        // 測試小數點位數為0的情況
        let result3 = 回合統計表.製表(table.達成次數, 0, Double(table.測試次數整數))
        assert(
            result3 == [
                ["10", "20", "30"],
                ["40", "50", "60"],
                ["70", "80", "90"]
            ],
            "製表結果(無小數點)不符合預期"
        )
    }
    
    private static func 旋轉後加標題(_ 圖表: [[String]], _ x軸範圍: ClosedRange<Int>) -> [[String]] {
        var array: [[String]] = 圖表
        
        //旋轉
        array = array.getGridArray(isRotate: true)
        
        //左標題
        for (index, element) in array.enumerated() {
            array[index] = ["\(index)"] + element
        }
        
        //上標題
        let title = [""] + x軸範圍.map({String($0)})
        array.insert(title, at: 0)
        
        return array
    }
    
    func 顯示結果(_ 類型: 顯示類型 = .JSON) {
        guard 類型 != .JSON else {
            print(self.jsonString!)
            return
        }
        
        var 達成次數 = 達成次數
        達成次數 = 回合統計表.加總(達成次數)
        達成次數 = 回合統計表.去尾(達成次數, 測試次數整數)
        let 文字表 = 回合統計表.製表(達成次數, 1, 測試次數)
        
        switch 類型 {
        case .JSON:
            break
        case .標準:
            顯示標準結果(文字表)
        case .表格:
            顯示表格結果(文字表)
        }
    }
    
    func 顯示比較結果(_ 類型: 顯示類型 = .表格, 比較 比較對象統計表: 回合統計表) {
        let biggerOne = max(self.測試次數整數, 比較對象統計表.測試次數整數)
        let smallerOne = min(self.測試次數整數, 比較對象統計表.測試次數整數)
        assert(biggerOne % smallerOne == 0, "不能被整除")
        
        let result = self.修改測試次數(biggerOne / self.測試次數整數)
        let anotherOne = 比較對象統計表.修改測試次數(biggerOne / 比較對象統計表.測試次數整數)
        result.達成次數 = 回合統計表.加總(result.達成次數)
        anotherOne.達成次數 = 回合統計表.加總(anotherOne.達成次數)
        
        let comparisonResult = result.差距次數(anotherOne)
        result.名稱 = comparisonResult.名稱
        comparisonResult.名稱 = "比較表"
        
        var resultTable = 回合統計表.製表(result.達成次數, 1, result.測試次數)
        let comparisonResultTable = 回合統計表.製表(comparisonResult.達成次數, 1, comparisonResult.測試次數)
        for x in (0 ..< resultTable.count) {
            for y in (0 ..< (resultTable.first?.count ?? 0)) {
                resultTable[x][y] += "(\(comparisonResultTable[x][y]))"
            }
        }
        
        switch 類型 {
        case .JSON:
            fatalError("不支援")
        case .標準:
            顯示標準結果(resultTable)
        case .表格:
            顯示表格結果(resultTable)
        }
    }
    
    private func 顯示標準結果(_ 文字表: [[String]]) {
        print(名稱 + "[\(測試次數整數)]")
        print(回合統計表.旋轉後加標題(文字表, x軸範圍).reduce("", {$0 + "\n" + $1.joined(separator: ",")}).dropFirst() + "\n")
    }
    
    private func 顯示表格結果(_ 文字表: [[String]]) {
        print(名稱 + "[\(測試次數整數)]")
        print(回合統計表.旋轉後加標題(文字表, x軸範圍).matterMostOutput())
    }
    
    static func 組合運算後結果(_ array: [回合統計表]) -> [回合統計表] {
        let 所有統計表名稱 = array.map(\.名稱).removeDuplicates()
        let 所有統計表分類: [[回合統計表]] = 所有統計表名稱.map({ 統計表名稱 in
            array.filter({$0.名稱 == 統計表名稱}).sorted(by: {$0.x軸範圍.lowerBound < $1.x軸範圍.lowerBound})
        })
        
        let 所有統計表: [回合統計表] = 所有統計表分類.map({
            guard $0.count > 1 else { return $0[0] }
            let first = $0.first!
            let last = $0.last!
            
            let result = 回合統計表.複製資料(first)
            result.x軸範圍 = first.x軸範圍.lowerBound ... last.x軸範圍.upperBound
            result.達成次數 = []
            
            $0.forEach({
                result.達成次數.append(contentsOf: $0.達成次數)
            })
            return result
        })
        
        return 所有統計表
    }
    
    static func 組合運算後顯示結果(_ array: [回合統計表]) -> [回合統計表] {
        let 所有統計表 = 組合運算後結果(array)
        
        for 統計表 in 所有統計表 {
            統計表.顯示結果()
        }
        return 所有統計表
    }
    
    
    private static func 測試合併() {
        // 創建測試用的統計表
        let tableA1 = 回合統計表()
        tableA1.重置(100, 名稱: "測試表A", 範圍: 1...2, 回合數上限: 2)
        tableA1.達成次數 = [
            [10, 20, 30],
            [40, 50, 60]
        ]
        
        let tableA2 = 回合統計表()
        tableA2.重置(100, 名稱: "測試表A", 範圍: 1...2, 回合數上限: 2)
        tableA2.達成次數 = [
            [70, 80, 90],
            [100, 110, 120]
        ]
        
        let tableB1 = 回合統計表()
        tableB1.重置(100, 名稱: "測試表B", 範圍: 1...2, 回合數上限: 2)
        tableB1.達成次數 = [
            [15, 25, 35],
            [45, 55, 65]
        ]
        
        let tableB2 = 回合統計表()
        tableB2.重置(100, 名稱: "測試表B", 範圍: 2...3, 回合數上限: 2)
        tableB2.達成次數 = [
            [15, 25, 35],
            [70, 80, 90]
        ]
        
        // 測試合併結果
        let result = 合併([tableA1, tableA2, tableB1, tableB2])
        
        // 驗證結果數量
        assert(result.count == 3, "合併後應該有3個統計表")
        
        // 驗證第一個合併結果（測試表A）
        let mergedTableA = result.first(where: { $0.名稱 == "測試表A" })!
        assert(mergedTableA.x軸範圍 == 1...2, "合併後的範圍不正確")
        assert(
            mergedTableA.達成次數 == [
                [80, 100, 120],
                [140, 160, 180]
            ],
            "合併後的數據不正確"
        )
        
        // 驗證第二個結果（測試表B）
        let mergedTableB1 = result.first(where: { $0.名稱 == "測試表B" })!
        assert(mergedTableB1.x軸範圍 == 1...2, "測試表B的範圍不應改變")
        assert(
            mergedTableB1.達成次數 == [
                [15, 25, 35],
                [45, 55, 65]
            ],
            "測試表B的數據不應改變"
        )
        let mergedTableB2 = result.last(where: { $0.名稱 == "測試表B" })!
        assert(mergedTableB2.x軸範圍 == 2...3, "測試表B的範圍不應改變")
        assert(
            mergedTableB2.達成次數 == [
                [15, 25, 35],
                [70, 80, 90]
            ],
            "測試表B的數據不應改變"
        )
    }
}

extension [回合統計表] {
    func 印出JSON(_ 名稱: String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let 現在日期 = dateFormatter.string(from: Date())
        let 名稱 = 名稱 ?? "array\(現在日期)"
        
        let 文字標註符號 = "\"\"\""
        print("let \(名稱) = [")
        
        for table in self {
            print(文字標註符號)
            print(table.jsonString!)
            print(文字標註符號)
            print(",")
        }
        print("]")
    }
}

let jsonArray = [
"""
{"目前x軸":2,"x軸範圍":[2,14],"測試次數":1000000,"測試次數整數":1000000,"名稱":"皮卡丘EX, 大木博士 > 精靈球","達成次數":[[4259,143763,107063,108198,119836,123709,119708,107164,87141,60163,16725,2271,0,0,0,0,0,0,0,0,0],[15771,236489,165685,145635,137831,116974,87943,56556,28149,7928,1039,0,0,0,0,0,0,0,0,0,0],[34897,319759,198363,151358,122512,85845,51433,25071,8795,1800,167,0,0,0,0,0,0,0,0,0,0],[61014,385915,205103,137223,95874,58541,31867,15600,6792,1844,227,0,0,0,0,0,0,0,0,0,0],[93050,432026,192421,114678,72695,43683,26019,15286,7623,2217,302,0,0,0,0,0,0,0,0,0,0],[130189,455007,169340,92487,58467,38644,26522,17158,9119,2718,349,0,0,0,0,0,0,0,0,0,0],[169791,458698,143181,76251,52658,38631,28279,18842,10337,2913,419,0,0,0,0,0,0,0,0,0,0],[212032,443003,119117,68011,51123,40410,30465,20574,11406,3414,445,0,0,0,0,0,0,0,0,0,0],[253821,414043,102925,64137,52330,42412,32001,21751,12414,3654,512,0,0,0,0,0,0,0,0,0,0],[296122,374496,93668,63963,53944,43445,33476,23178,13197,3975,536,0,0,0,0,0,0,0,0,0,0],[335073,330313,91134,65078,55340,44871,34621,24489,14131,4307,643,0,0,0,0,0,0,0,0,0,0],[372476,286295,91896,66694,56253,45873,35366,25231,14796,4455,665,0,0,0,0,0,0,0,0,0,0],[402388,248262,93209,67821,57796,47162,36639,25913,15242,4868,700,0,0,0,0,0,0,0,0,0,0]]}
"""
,

"""
{"測試次數整數":1000000,"x軸範圍":[2,14],"測試次數":1000000,"達成次數":[[4116,130506,107291,109356,122209,125977,121896,109294,89078,61087,16926,2264,0,0,0,0,0,0,0,0,0],[15724,225686,167885,147447,140033,118926,89053,57250,29025,7972,999,0,0,0,0,0,0,0,0,0,0],[35320,310797,200874,154051,123845,86975,52323,25152,8711,1810,142,0,0,0,0,0,0,0,0,0,0],[60931,379747,207420,138970,96839,59492,32174,15631,6796,1783,217,0,0,0,0,0,0,0,0,0,0],[93472,427405,194450,115309,73342,44039,26397,15448,7659,2215,264,0,0,0,0,0,0,0,0,0,0],[129900,452329,170547,93384,58941,38863,26682,17102,9280,2655,317,0,0,0,0,0,0,0,0,0,0],[169215,456448,144814,76670,52651,38634,28628,19247,10363,2932,398,0,0,0,0,0,0,0,0,0,0],[211083,442005,120129,68210,51660,40884,30333,20716,11205,3324,451,0,0,0,0,0,0,0,0,0,0],[254464,412874,103164,64634,52557,42171,31913,21719,12266,3722,516,0,0,0,0,0,0,0,0,0,0],[295181,373855,93949,64614,53966,43664,33594,23331,13301,3998,547,0,0,0,0,0,0,0,0,0,0],[335914,329230,91234,65559,55743,44898,34174,24173,14037,4418,620,0,0,0,0,0,0,0,0,0,0],[370973,286437,92731,67046,56280,46456,35586,24871,14598,4382,640,0,0,0,0,0,0,0,0,0,0],[402273,248417,93264,67560,57730,47179,36547,26166,15402,4815,647,0,0,0,0,0,0,0,0,0,0]],"名稱":"皮卡丘EX, 精靈球 > 大木博士","目前x軸":2}
"""
,
"""
{"名稱":"皮卡丘EX, 無","測試次數整數":1000000,"x軸範圍":[2,14],"測試次數":1000000,"達成次數":[[4085,6352,10278,15525,21620,28609,37245,46744,56891,68345,80537,94192,107986,123862,139807,157922,0,0,0,0,0],[15588,21578,33360,46375,59429,72137,83769,92302,99569,102229,100828,93700,81531,62522,35083,0,0,0,0,0,0],[34588,44369,63357,80703,94854,104266,108674,106836,99697,87461,70329,51958,33170,15846,3892,0,0,0,0,0,0],[61226,69823,92832,109497,116905,116268,107767,94143,77000,58832,41343,26493,15379,8283,4209,0,0,0,0,0,0],[92766,96462,118063,126839,123922,110572,92643,73156,54398,39077,27090,18646,13144,8851,4371,0,0,0,0,0,0],[129706,120968,134569,132325,116833,95978,74381,55102,41070,30269,23485,18296,13498,9075,4445,0,0,0,0,0,0],[169386,140462,143135,127498,103187,79031,59273,44294,35062,28575,23429,18668,14085,9307,4608,0,0,0,0,0,0],[211942,154189,142143,115007,87444,65012,49461,40377,33651,28611,23669,19454,14568,9735,4737,0,0,0,0,0,0],[254528,159793,133875,100817,73194,56411,46050,39222,34049,29144,24440,19288,14795,9542,4852,0,0,0,0,0,0],[295683,159542,120524,85869,63720,52022,45041,39091,34802,29445,24788,19909,14842,9703,5019,0,0,0,0,0,0],[334872,151839,105451,73943,58494,50233,45258,40254,34702,29705,25004,20105,14916,10209,5015,0,0,0,0,0,0],[371145,136871,90566,66606,56210,50486,45556,40462,35125,30521,25548,20598,15238,10009,5059,0,0,0,0,0,0],[402461,119884,78076,62376,56011,51157,46089,41006,35694,30642,25382,20564,15368,10188,5102,0,0,0,0,0,0]],"目前x軸":2}
"""
]
