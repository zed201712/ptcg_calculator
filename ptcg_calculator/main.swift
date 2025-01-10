//
//  main.swift
//  ptcg_calculator
//
//  Created by Yuu on 2025/1/1.
//

import Foundation

//皮卡丘
//寶石海星
//沙奈朵牌組

//幻之石板
//紅卡

let debug_flags = Array(repeating: true, count: 1)
//let debug_flags = [false, true, false, true]
//let debug_flags = [false, true, true]
func debug_msg(_ 玩家: 寶可夢玩家, _ flagIndex: Int, _ array: String...) {
    guard debug_flags[safe: flagIndex] == true else { return }
    print("\(玩家.先手玩家 ? "先手" : "後手") : " + array.joined(separator: ", "))
    
    if //玩家.先手玩家,
       debug_flags[safe: 3] == true
    {
        print("\(玩家.先手玩家 ? "先手" : "後手") : " + 玩家.牌堆資訊())
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

func main() {
    let startTime = Date()
    
    let model = 模擬抽皮卡丘EX()
    //let model = 模擬抽寶石海星()
    //let model = 模擬抽沙奈朵()
    //let model = 模擬用紅卡();model.調整紅卡玩家基礎寶可夢(6)
    //let result = model.loop(1_000_000)
    //let result = model.loop(20_000)
    let result = model.loop(300)
    //model.loop(1)
    
    //實體測試者.執行所有測試()
    //回合統計表.執行所有測試()
    
    let endTime = Date(); let costTime = Int(endTime.timeIntervalSince(startTime).rounded())
    print("花費時間: \(costTime) 秒")
    
    let tableArray = jsonArray.map({回合統計表(json: $0)!})
    //tableArray.印出JSON("jsonArray")
//    for table in tableArray {
//        table.顯示結果()
//    }
    
    //TODO
    result[0].顯示結果(.表格)
    tableArray[2].顯示結果(.表格)
    let newArray = 回合統計表.合併(tableArray + result)
    print("newArray[\(newArray.count)]")
    newArray[2].顯示結果(.表格)
    //TODO
    
    //TODO
    //result.first!.顯示比較結果(比較: tableArray[2])
    //TODO
}
main()

extension Double {
    func 小數點後(_ 位數: Int) -> String {
        guard 位數 > 0 else { return String(self) }
        
        let formatTxt = "%.\(位數)f"
        return .init(format: formatTxt, self)
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
}

class 模擬單次抽牌 {
    private var 抽牌數: Int = 5
    private var 關鍵牌數 = 1
    
    private let 統計表 = 回合統計表()
    private var 已完成 = false
    var 牌組: [寶可夢牌] = []
    
    private func 測試(_ 成功判定: (Int)->Bool) {
        var 牌組 = 牌組.shuffled()
        let 手牌 = 牌組.抽(數量: 抽牌數)
        let 抽到關鍵牌數 = 手牌.有幾張({$0 == .雜牌基礎寶可夢})
        guard 成功判定(抽到關鍵牌數) else { return }
        統計表.加次數(0)
    }
    
    func loop(_ 測試次數: Int, 抽牌數: Int, 牌組數量上限: Int, 關鍵牌數: Int, 顯示結果: Bool = true, 成功判定: @escaping(Int)->Bool) {
        self.抽牌數 = 抽牌數
        self.關鍵牌數 = 關鍵牌數
        self.牌組 = .init(雜牌數: 牌組數量上限 - 關鍵牌數, 雜牌基礎寶可夢數: 關鍵牌數)
        
        let 關鍵牌數範圍 = 關鍵牌數 ... 關鍵牌數
        let 統計表名稱 = "模擬單回全部命中: \(牌組數量上限)張, 抽\(抽牌數)張, 關鍵牌\(關鍵牌數)張"
        統計表.重置(測試次數, 名稱: 統計表名稱, 範圍: 關鍵牌數範圍, 回合數上限: 1)
        統計表.設定(數量: 關鍵牌數)
        for _ in 0 ..< 測試次數 {
            測試(成功判定)
        }
        
        if 顯示結果 { 統計表.顯示結果() }
    }
}

class 模擬用紅卡: 寶可夢TCG控制器 {
    typealias 目前測試玩家 = 沙奈朵玩家
    let 遊戲: 寶可夢TCG = .init(所有玩家: [目前測試玩家(), 紅卡玩家.後手陪練玩家()])
    var 玩家: 目前測試玩家 {遊戲.所有玩家.first as! 目前測試玩家}
    var 對手: 紅卡玩家 {遊戲.所有玩家[1]  as! 紅卡玩家}
    
    var 目前模型: 模擬用紅卡 {
        模擬用紅卡()
    }
    
    var 先手玩家出牌策略: [寶可夢出牌策略] {[
        .init(牌: .幻之石板, 只出一張: false),
        .init(牌: .大木博士, 只出一張: true),
        .init(牌: .精靈球, 只出一張: false),
    ]}
    
    var 紅卡玩家出牌策略: [寶可夢出牌策略] {[
        .init(牌: .大木博士, 只出一張: true),
        .init(牌: .精靈球, 只出一張: false),
    ]}
    
    var 統計表名稱: String { "模擬用紅卡"}
    var 統計表名稱後綴: String { " vs 沙奈朵"}
    func 計算雜牌基礎寶可夢數量範圍(_ 統計表: 回合統計表) -> ClosedRange<Int> {
        統計表.重置牌組計算範圍(玩家, 最低: 0)
    }
    
    private let 統計表 = 回合統計表()
    private var 目前測試數: Int = 0
    private var 已完成 = false
    private var 紅卡玩家基礎寶可夢數量 = 0
    
    private let 紅卡目標卡: 寶可夢牌 = .拉魯拉絲
    
    private func 紅卡玩家出牌策略(_ 玩家: 寶可夢玩家) {
        let 紅卡玩家 = 玩家
        let 紅卡玩家對手 = 玩家.對手
        guard 紅卡玩家對手!.棄牌堆.有({$0 == 紅卡目標卡}) else { return }
        _ = 紅卡玩家.執行出牌策略(.init(牌: .紅卡, 只出一張: false))
    }
    
    func 回合結束(_ 玩家: 寶可夢玩家) {
        guard 玩家 === self.玩家 else {
            紅卡玩家出牌策略(玩家)
            return
        }
        
        let 紅牌對策張數 = 3
        
        guard 紅牌對策張數 < 玩家.手牌.count else { return }
        let 差 = 玩家.手牌.count - 紅牌對策張數
        let 丟牌前數量 = 玩家.手牌.count
        for _ in (0 ..< 差) {
            if 紅牌對策張數 < 玩家.手牌.count { _ = 玩家.棄牌(.雜牌) }
            if 紅牌對策張數 < 玩家.手牌.count { _ = 玩家.棄牌(.雜牌基礎寶可夢) }
            if 紅牌對策張數 < 玩家.手牌.count { _ = 玩家.棄牌(.幻之石板) }
        }
        
//        if 玩家.手牌.count > 3 {
//            let 手牌資訊 = "\(玩家.牌堆資訊([\.手牌]))"
//            print("\(丟牌前數量) -> \(玩家.手牌.count)[\(手牌資訊)]")
//        }
    }
    
    func 是否遊戲結束() -> Bool {
        return 玩家.棄牌堆.有({$0 == .沙奈朵})
    }
    
    func 遊戲結束() {
        統計表.加次數(遊戲.目前回合)
    }
    
    func 調整紅卡玩家基礎寶可夢(_ 數量: Int) {
        紅卡玩家基礎寶可夢數量 = 數量
        對手.重置牌組(雜牌: 數量)
    }
    
    private func 測試(_ 測試次數: Int, _ x: Int) {
        已完成 = false
        
        self.遊戲.控制器 = self
        
        let 統計表名 = "\(統計表名稱)\(統計表名稱後綴), " + 對手.出牌策略.順序名() + ", " + 玩家.出牌策略.順序名()
        統計表.重置(測試次數, 名稱: 統計表名, 範圍: x ... x, 回合數上限: 遊戲.牌組數量上限)
        統計表.設定(數量: x)
        玩家.重置牌組(雜牌: x)
        for 次數 in 0 ..< 測試次數 {
            目前測試數 = 次數
            遊戲.重新開始()
        }
        
        已完成 = true
    }
    
    func loop(_ 測試次數: Int) -> [回合統計表] {
        let 雜牌基礎寶可夢數量範圍 = 計算雜牌基礎寶可夢數量範圍(統計表)
        let 先手玩家出牌策略 = 先手玩家出牌策略
        let 紅卡玩家出牌策略 = 紅卡玩家出牌策略
        
        let 統計表數量 = 雜牌基礎寶可夢數量範圍.count
        let 模型: [模擬用紅卡] = (0 ..< 統計表數量).map({_ in self.目前模型})
        for 雜牌基礎寶可夢數量 in 雜牌基礎寶可夢數量範圍 {
            let 模型編號 = (雜牌基礎寶可夢數量 - 雜牌基礎寶可夢數量範圍.lowerBound)
            模型[模型編號].調整紅卡玩家基礎寶可夢(紅卡玩家基礎寶可夢數量)
            模型[模型編號].玩家.出牌策略 = 先手玩家出牌策略
            模型[模型編號].對手.出牌策略 = 紅卡玩家出牌策略
            
            DispatchQueue.global().async {
                模型[模型編號].測試(測試次數, 雜牌基礎寶可夢數量)
            }
        }
        
        while (模型.first(where: {$0.已完成 == false}) != nil) {
            sleep(1)
            let 百分比 = Int(Double(模型[0].目前測試數) / Double(測試次數) * 100)
            print("測試次數 \(模型[0].目前測試數) / \(測試次數) = \(百分比)")
        }
        
        return 回合統計表.組合運算後顯示結果(模型.map({$0.統計表}))
    }
}

class 模擬抽寶石海星: 模擬抽沙奈朵 {
    override var 統計表名稱: String { "寶石海星" }
    
    override var 目前模型: 模擬抽沙奈朵 {
        模擬抽寶石海星()
    }
    
    override var 出牌策略: [寶可夢出牌策略] {[
//        .init(牌: .大木博士, 只出一張: true),
//        .init(牌: .精靈球, 只出一張: false),
    ]}
    
    override func 是否遊戲結束() -> Bool {
        return 玩家.棄牌堆.有({$0 == .奇魯莉安})
    }
    
    func 數學驗證() {
        for 回合 in 2 ... 10 {
            let result = MathCombination().drawKeyCard(19, keyCardCount: 2, drawCardCount: 5 - 1 + 回合)
            print("寶石海星 回合\(回合): " + (result * 100).toDotString(1))
        }
        //簡易模型驗證
        //let simpleModel = 模擬單次抽牌(); simpleModel.loop(300_000, 抽牌數: 5 - 1 + 10, 牌組數量上限: 19, 關鍵牌數: 2) {$0 >= 1}
        //無出牌策略
//        寶石海星 回合2: 54.4
//        寶石海星 回合3: 61.4
//        寶石海星 回合4: 67.8
//        寶石海星 回合5: 73.7
//        寶石海星 回合6: 78.9
//        寶石海星 回合7: 83.6
//        寶石海星 回合8: 87.7
//        寶石海星 回合9: 91.2
//        寶石海星 回合10: 94.2
//        寶石海星 回合11: 96.5
//        寶石海星 回合12: 98.2
//        寶石海星 回合13: 99.4
//        寶石海星 回合14: 100.0
    }
}

class 模擬抽沙奈朵: 寶可夢TCG控制器 {
    typealias 目前測試玩家 = 沙奈朵玩家
    let 遊戲: 寶可夢TCG = .init(所有玩家: [目前測試玩家()])
    var 玩家: 目前測試玩家 {遊戲.所有玩家.first as! 目前測試玩家}
    
    var 目前模型: 模擬抽沙奈朵 {
        模擬抽沙奈朵()
    }
    
    var 出牌策略: [寶可夢出牌策略] {[
//        .init(牌: .幻之石板, 只出一張: false),
        .init(牌: .大木博士, 只出一張: true),
        .init(牌: .精靈球, 只出一張: false),
    ]}
    
    var 統計表名稱: String { "沙奈朵" }
    func 計算雜牌基礎寶可夢數量範圍(_ 統計表: 回合統計表) -> ClosedRange<Int> {
        統計表.重置牌組計算範圍(玩家, 最低: 0)
    }
    
    private let 統計表 = 回合統計表()
    private var 目前測試數: Int = 0
    private var 已完成 = false
    
    func 回合結束(_ 玩家: 寶可夢玩家) {}
    func 是否遊戲結束() -> Bool {
        return 玩家.棄牌堆.有({$0 == .沙奈朵})
    }
    
    func 遊戲結束() {
        統計表.加次數(遊戲.目前回合)
    }
    
    private func 測試(_ 測試次數: Int, _ x: Int) {
        已完成 = false
        
        self.遊戲.控制器 = self
        
        let 統計表名 = "\(統計表名稱), " + 玩家.出牌策略.順序名()
        統計表.重置(測試次數, 名稱: 統計表名, 範圍: x ... x, 回合數上限: 遊戲.牌組數量上限)
        統計表.設定(數量: x)
        玩家.重置牌組(雜牌: x)
        for 次數 in 0 ..< 測試次數 {
            目前測試數 = 次數
            遊戲.重新開始()
        }
        
        已完成 = true
    }
    
    func loop(_ 測試次數: Int) -> [回合統計表] {
        let 雜牌基礎寶可夢數量範圍 = 計算雜牌基礎寶可夢數量範圍(統計表)
        let 所有出牌順序 = 出牌策略.所有順序()
        
        let 統計表數量 = 所有出牌順序.count * 雜牌基礎寶可夢數量範圍.count
        let 模型: [模擬抽沙奈朵] = (0 ..< 統計表數量).map({_ in self.目前模型})
        所有出牌順序.enumerated().forEach { 出牌順序編號, 出牌策略 in
            for 雜牌基礎寶可夢數量 in 雜牌基礎寶可夢數量範圍 {
                let 模型編號 = 出牌順序編號 * 雜牌基礎寶可夢數量範圍.count + (雜牌基礎寶可夢數量 - 雜牌基礎寶可夢數量範圍.lowerBound)
                
                DispatchQueue.global().async {
                    模型[模型編號].玩家.出牌策略 = 出牌策略
                    模型[模型編號].測試(測試次數, 雜牌基礎寶可夢數量)
                }
            }
        }
        
        while (模型.first(where: {$0.已完成 == false}) != nil) {
            sleep(1)
            let 百分比 = Int(Double(模型[0].目前測試數) / Double(測試次數) * 100)
            print("測試次數 \(模型[0].目前測試數) / \(測試次數) = \(百分比)")
        }
        
        return 回合統計表.組合運算後顯示結果(模型.map({$0.統計表}))
    }
}

class 模擬抽皮卡丘EX: 寶可夢TCG控制器 {
    typealias 目前測試玩家 = 皮卡丘EX玩家
    let 遊戲: 寶可夢TCG = .init(所有玩家: [目前測試玩家()])
    private var 玩家: 目前測試玩家 {遊戲.所有玩家.first as! 目前測試玩家}
    
    var 目前模型: 模擬抽皮卡丘EX {
        模擬抽皮卡丘EX()
    }
    
    var 出牌策略: [寶可夢出牌策略] {[
//        .init(牌: .大木博士, 只出一張: true),
//        .init(牌: .精靈球, 只出一張: false),
    ]}
    
    var 統計表名稱: String { "皮卡丘EX" }
    
    private let 統計表 = 回合統計表()
    private var 目前測試數: Int = 0
    private var 已完成 = false
    
    func 數學驗證() {
        for 回合 in 1 ... 20 {
            let result = MathCombination().drawKeyCardAllHit(19, keyCardCount: 3, drawCardCount: 5 - 1 + 回合)
            print("皮卡丘 回合\(回合): " + (result * 100).toDotString(1))
        }
        //簡易模型驗證
        //let simpleModel = 模擬單次抽牌(); simpleModel.loop(300_000, 抽牌數: 5 - 1 + 7, 牌組數量上限: 19, 關鍵牌數: 3) {$0 >= 3}
        
        //無出牌策略
        //皮卡丘 回合1: 1.0
        //皮卡丘 回合2: 2.1
        //皮卡丘 回合3: 3.6
        //皮卡丘 回合4: 5.8
        //皮卡丘 回合5: 8.7
        //皮卡丘 回合6: 12.4
        //皮卡丘 回合7: 17.0
        //皮卡丘 回合8: 22.7
        //皮卡丘 回合9: 29.5
        //皮卡丘 回合10: 37.6
        //皮卡丘 回合11: 47.0
        //皮卡丘 回合12: 57.8
        //皮卡丘 回合13: 70.2
        //皮卡丘 回合14: 84.2
        //皮卡丘 回合15: 100.0
    }
    
    func 回合結束(_ 玩家: 寶可夢玩家) {}
    func 是否遊戲結束() -> Bool {
        let 基礎寶可夢充足 = 玩家.手牌.有幾張({$0.是基礎寶可夢()}) >= 4
        let 有皮卡丘 = 玩家.手牌.有({$0 == .皮卡丘EX})
        return 有皮卡丘 && 基礎寶可夢充足
    }
    
    func 遊戲結束() {
        統計表.加次數(遊戲.目前回合)
    }
    
    private func 測試(_ 測試次數: Int, _ x: Int) {
        已完成 = false
        
        self.遊戲.控制器 = self
        
        let 統計表名 = "\(統計表名稱), " + 玩家.出牌策略.順序名()
        統計表.重置(測試次數, 名稱: 統計表名, 範圍: x ... x, 回合數上限: 遊戲.牌組數量上限)
        統計表.設定(數量: x)
        玩家.重置牌組(雜牌: x)
        for 次數 in 0 ..< 測試次數 {
            目前測試數 = 次數
            遊戲.重新開始()
        }
        
        已完成 = true
    }
    
    func loop(_ 測試次數: Int) -> [回合統計表] {
        let 雜牌基礎寶可夢數量範圍 = 統計表.重置牌組計算範圍(玩家, 最低: 2)
        let 所有出牌順序 = 出牌策略.所有順序()
        
        let 統計表數量 = 所有出牌順序.count * 雜牌基礎寶可夢數量範圍.count
        let 模型: [模擬抽皮卡丘EX] = (0 ..< 統計表數量).map({_ in self.目前模型})
        所有出牌順序.enumerated().forEach { 出牌順序編號, 出牌策略 in
            for 雜牌基礎寶可夢數量 in 雜牌基礎寶可夢數量範圍 {
                let 模型編號 = 出牌順序編號 * 雜牌基礎寶可夢數量範圍.count + (雜牌基礎寶可夢數量 - 雜牌基礎寶可夢數量範圍.lowerBound)
                
                DispatchQueue.global().async {
                    模型[模型編號].玩家.出牌策略 = 出牌策略
                    模型[模型編號].測試(測試次數, 雜牌基礎寶可夢數量)
                }
            }
        }
        
        while (模型.first(where: {$0.已完成 == false}) != nil) {
            sleep(1)
            let 百分比 = Int(Double(模型[0].目前測試數) / Double(測試次數) * 100)
            print("測試次數 \(模型[0].目前測試數) / \(測試次數) = \(百分比)")
        }
        
        return 回合統計表.組合運算後顯示結果(模型.map({$0.統計表}))
    }
}

protocol 寶可夢TCG控制器: AnyObject {
    func 回合結束(_ 玩家: 寶可夢玩家)
    func 是否遊戲結束() -> Bool
    func 遊戲結束()
}

class 寶可夢TCG {
    static let 預設牌組數量上限 = 20
    static let 預設同卡上限 = 2
    
    var 牌組數量上限: Int = 寶可夢TCG.預設牌組數量上限
    var 同卡上限: Int = 寶可夢TCG.預設同卡上限
    
    weak var 控制器: 寶可夢TCG控制器?
    
    private(set) var 目前回合: Int = 0
    
    let 所有玩家: [寶可夢玩家]
    init(所有玩家: [寶可夢玩家]) {
        let 所有玩家 = (所有玩家.count == 1) ? (所有玩家 + [陪練玩家.後手陪練玩家()]) : 所有玩家
        
        self.所有玩家 = 所有玩家
        
        玩家行動 { 玩家 in
            玩家.遊戲 = self
        }
    }
    
    func 目前為可進化回合() -> Bool {
        //第1回合不可進化
        目前回合 > 1
    }
    
    func 重新開始() {
        重置()
        準備()
        開始()
    }
    
    func 重置() {
        目前回合 = 0
        玩家行動 { 玩家 in
            玩家.重置()
        }
    }
    
    func 準備() {
        玩家行動 { 玩家 in
            玩家.準備()
        }
    }
    
    func 開始() {
        目前回合 = 0
        
        var 已結束 = 詢問遊戲結束()
        if 已結束 {遊戲結束(所有玩家[0])}
        while !已結束 {
            目前回合 += 1
            for 玩家 in 所有玩家 {
                玩家.新回合()
                
                //debug_msg(玩家, 2, "\(#function)")
                控制器?.回合結束(玩家)
                
                已結束 = 詢問遊戲結束()
                if 已結束 {
                    遊戲結束(玩家)
                    break
                }
            }
        }
    }
    
    private func 遊戲結束(_ 玩家: 寶可夢玩家) {
        //debug_msg(玩家, 1, "遊戲結束")
        控制器?.遊戲結束()
    }
    
    private func 詢問遊戲結束() -> Bool {
        guard let 控制器 else { return 目前回合 > 20 }
        return 控制器.是否遊戲結束()
    }
    
    private func 玩家行動(callback: (寶可夢玩家)->Void) {
        self.所有玩家.forEach {callback($0)}
    }
}

struct 寶可夢出牌策略: Hashable, Equatable {
    let 牌: 寶可夢牌
    let 只出一張: Bool
}
extension Array where Element == 寶可夢出牌策略 {
    func 所有順序() -> [[寶可夢出牌策略]] {
        let array = AllCasesTester.permutations(of: self)
        return array.isEmpty ? [[]] : array
    }
    
    func 順序名(_ emptyName: String = "無") -> String {
        self.isEmpty ? emptyName : self.map({$0.牌.名稱}).joined(separator: " > ")
    }
}

enum 寶可夢卡類型: CaseIterable, Hashable, Equatable {
    case 基礎
    case 一階, 二階
    case 物品
    case 支援者
}
enum 寶可夢屬性: CaseIterable, Hashable, Equatable {
    case 草, 火, 水, 雷, 超, 鬥, 惡, 鋼, 龍, 無
}
struct 寶可夢牌: Hashable, Equatable {
    let 名稱: String
    let 類型: 寶可夢卡類型
    let 屬性: 寶可夢屬性?
    
    func 是寶可夢() -> Bool {
        self.類型 == .基礎
        || self.類型 == .一階
        || self.類型 == .二階
    }
    
    func 是支援者() -> Bool {
        self.類型 == .支援者
    }
    func 是基礎寶可夢() -> Bool {
        self.類型 == .基礎
    }
    func 是雜牌() -> Bool {
        self == .雜牌 || self == .雜牌基礎寶可夢
    }
}
extension 寶可夢牌 {
    static let 雜牌基礎寶可夢: 寶可夢牌 = .init(
        名稱: "雜牌基礎寶可夢",
        類型: .基礎,
        屬性: nil
    )
    static let 雜牌1階寶可夢: 寶可夢牌 = .init(
        名稱: "雜牌基礎寶可夢",
        類型: .一階,
        屬性: nil
    )
    static let 雜牌超基礎寶可夢: 寶可夢牌 = .init(
        名稱: "雜牌超基礎寶可夢",
        類型: .基礎,
        屬性: .超
    )
    static let 雜牌超1寶可夢: 寶可夢牌 = .init(
        名稱: "雜牌超1寶可夢",
        類型: .一階,
        屬性: .超
    )
    static let 拉魯拉絲: 寶可夢牌 = .init(
        名稱: "拉魯拉絲",//Ralts
        類型: .基礎,
        屬性: .超
    )
    static let 奇魯莉安: 寶可夢牌 = .init(
        名稱: "奇魯莉安",//Kirlia
        類型: .一階,
        屬性: .超
    )
    static let 沙奈朵: 寶可夢牌 = .init(
        名稱: "沙奈朵",//Gardevoir
        類型: .二階,
        屬性: .超
    )
    static let 超夢EX: 寶可夢牌 = .init(
        名稱: "超夢EX",
        類型: .基礎,
        屬性: .超
    )
    static let 皮卡丘EX: 寶可夢牌 = .init(
        名稱: "皮卡丘EX",
        類型: .基礎,
        屬性: .雷
    )
    static let 海星星: 寶可夢牌 = .init(
        名稱: "海星星",
        類型: .基礎,
        屬性: .水
    )
    static let 寶石海星EX: 寶可夢牌 = .init(
        名稱: "寶石海星EX",
        類型: .一階,
        屬性: .水
    )
    static let 噴火龍EX: 寶可夢牌 = .init(
        名稱: "噴火龍EX",
        類型: .二階,
        屬性: .火
    )
    static let 雜牌: 寶可夢牌 = .init(
        名稱: "雜牌",
        類型: .物品,
        屬性: nil
    )
    static let 精靈球: 寶可夢牌 = .init(
        名稱: "精靈球",
        類型: .物品,
        屬性: nil
    )
    static let 幻之石板: 寶可夢牌 = .init(
        名稱: "幻之石板",
        類型: .物品,
        屬性: nil
    )
    static let 大木博士: 寶可夢牌 = .init(
        名稱: "大木博士",
        類型: .支援者,
        屬性: nil
    )
    static let 紅卡: 寶可夢牌 = .init(
        名稱: "紅卡",
        類型: .物品,
        屬性: nil
    )
}
extension Array where Element == 寶可夢牌 {
    static let 博士與精靈球: [寶可夢牌] = .init(同卡: .大木博士) + .init(同卡: .精靈球)
    
    init(牌: 寶可夢牌, 數量: Int) {
        self = Array(repeating: 牌, count: 數量)
    }
    
    init(同卡: 寶可夢牌, 同卡上限: Int = 寶可夢TCG.預設同卡上限) {
        self = .init(牌: 同卡, 數量: 同卡上限)
    }
    
    init(雜牌數: Int, 雜牌基礎寶可夢數: Int) {
        self = .init(牌: .雜牌, 數量: 雜牌數) + .init(牌: .雜牌基礎寶可夢, 數量: 雜牌基礎寶可夢數)
    }
    
    func 有(_ 條件: (寶可夢牌)->Bool) -> Bool {
        self.first(where: 條件) != nil
    }
    
    func 有幾張(_ 條件: (寶可夢牌)->Bool) -> Int {
        self.filter(條件).count
    }
    
    func 補牌組(_ 卡: 寶可夢牌, 加入 數量: Int, 數量上限: Int) -> [寶可夢牌] {
        var cards: [寶可夢牌] = self
        
        let maxCount = 數量上限 - cards.count
        let 數量 = Swift.min(maxCount, 數量)
        cards += .init(牌: 卡, 數量: 數量)
        return cards
    }
    
    func 補雜牌(_ 雜牌基礎寶可夢數量: Int, 數量上限: Int) -> [寶可夢牌] {
        補牌組(.雜牌基礎寶可夢, 加入: 雜牌基礎寶可夢數量, 數量上限: 數量上限).補雜牌(數量上限)
    }
    
    func 補雜牌(_ 數量上限: Int) -> [寶可夢牌] {
        let 雜牌數 = 數量上限 - count
        guard 雜牌數 > 0 else { return self }
        
        return self + .init(牌: .雜牌, 數量: 雜牌數)
    }
    
    mutating func 抽(_ 條件: (寶可夢牌)->Bool) -> 寶可夢牌? {
        guard let index = self.firstIndex(where: 條件) else { return nil }
        defer { self.remove(at: index) }
        return self[index]
    }
    
    mutating func 抽(數量: Int) -> [寶可夢牌] {
        let 被抽走的牌 = self.prefix(數量)
        let 被抽走數量 = 被抽走的牌.count
        self = self.suffix(count - 被抽走數量)
        return Array(被抽走的牌)
    }
}

class 紅卡玩家: 寶可夢玩家 {
    static func 後手陪練玩家() -> 紅卡玩家 {
        let 玩家 = 紅卡玩家()
        玩家.先手玩家 = false
        return 玩家
    }
    
    override func 取得核心牌組() -> [寶可夢牌] {
        let cards: [寶可夢牌] = .博士與精靈球 + [.紅卡]
        return cards
    }
}

class 陪練玩家: 寶可夢玩家 {
    static func 後手陪練玩家() -> 陪練玩家 {
        let 玩家 = 陪練玩家()
        玩家.先手玩家 = false
        return 玩家
    }
    
    override func 取得核心牌組() -> [寶可夢牌] {
        let cards: [寶可夢牌] = .init(牌: .雜牌基礎寶可夢, 數量: 1)
        return cards
    }
    override func 新回合() {}
}

class 皮卡丘EX玩家: 寶可夢玩家 {
    override func 取得核心牌組() -> [寶可夢牌] {
        .init(同卡: .皮卡丘EX)
        + .博士與精靈球
    }
}

class 沙奈朵玩家: 寶可夢玩家 {
    override func 取得核心牌組() -> [寶可夢牌] {
        .init(同卡: .沙奈朵)
        + .init(同卡: .奇魯莉安)
        + .init(同卡: .拉魯拉絲)
        + .init(同卡: .幻之石板)
        + .博士與精靈球
    }
    
    override func 出牌階段() {
        super.出牌階段()
        出關鍵牌如果能()
    }
    
    private func 出關鍵牌如果能() {
        //debug_msg(self, 1, "\(#function)")
        
        let 上回合幾張拉魯拉絲 = 棄牌堆.有幾張({$0 == .拉魯拉絲})
        let 上回合幾張奇魯莉安 = 棄牌堆.有幾張({$0 == .奇魯莉安})
        let 上回合幾張沙奈朵 = 棄牌堆.有幾張({$0 == .沙奈朵})
        
        for _ in 0 ..< 遊戲!.同卡上限 {
            _ = 棄牌(.拉魯拉絲)
        }
        guard 遊戲!.目前為可進化回合() else { return }
        
        let 拉魯拉絲奇魯莉安張數差 = 上回合幾張拉魯拉絲 - 上回合幾張奇魯莉安
        for _ in 0 ..< 拉魯拉絲奇魯莉安張數差 {
            _ = 棄牌(.奇魯莉安)
        }
        let 奇魯莉安沙奈朵張數差 = 上回合幾張奇魯莉安 - 上回合幾張沙奈朵
        for _ in 0 ..< 奇魯莉安沙奈朵張數差 {
            _ = 棄牌(.沙奈朵)
        }
    }
}

class 寶可夢玩家 {
    weak var 遊戲: 寶可夢TCG?
    var 對手: 寶可夢玩家? {遊戲?.所有玩家.first(where: {$0 !== self})}
    var 先手玩家: Bool = true
    var 牌組數量上限: Int {遊戲?.牌組數量上限 ?? 寶可夢TCG.預設牌組數量上限}
    var 同卡上限: Int {遊戲?.同卡上限 ?? 寶可夢TCG.預設同卡上限}
    
    var 出牌策略: [寶可夢出牌策略] = [
        .init(牌: .大木博士, 只出一張: true),
        .init(牌: .精靈球, 只出一張: false),
    ]
    
    private var 當前回合未使用支援者: Bool = true
    
    private lazy var 牌組: [寶可夢牌] = 預設牌組()
    
    private(set) var 手牌: [寶可夢牌] = []
    private(set) var 抽牌堆: [寶可夢牌] = []
    private(set) var 棄牌堆: [寶可夢牌] = []
    
    func 顯示牌堆資訊(_ 牌堆名稱: [KeyPath<寶可夢玩家, [寶可夢牌]>] = [\.手牌, \.抽牌堆, \.棄牌堆]) {
        print("_______________")
        print(牌堆資訊(牌堆名稱))
    }
    
    func 牌堆資訊(_ 牌堆名稱: [KeyPath<寶可夢玩家, [寶可夢牌]>] = [\.手牌, \.抽牌堆, \.棄牌堆]) -> String {
        牌堆名稱.map({
            let 牌堆 = self[keyPath: $0]
            let name = "\($0)".components(separatedBy: ".").last!
            return "\(name)[\(牌堆.count)]: \(牌堆.map(\.名稱).joined(separator: ", "))"
        }).joined(separator: ", ")
    }
    
    func 牌堆數量資訊(_ 牌堆名稱: [KeyPath<寶可夢玩家, [寶可夢牌]>] = [\.手牌, \.抽牌堆, \.棄牌堆]) -> String {
        牌堆名稱.map({
            let 牌堆 = self[keyPath: $0]
            let name = "\($0)".components(separatedBy: ".").last!
            return ("\(name)[\(牌堆.count)]")
        }).joined(separator: ", ")
    }
    
    func 取得核心牌組() -> [寶可夢牌] {
        return .init(牌: .雜牌基礎寶可夢, 數量: 2) + .博士與精靈球
    }
    
    func 預設牌組() -> [寶可夢牌] {
        取得核心牌組().補雜牌(牌組數量上限)
    }
    
    func 測試用重置抽牌堆(_ 牌組: [寶可夢牌]) {
        //debug_msg(self, 1, "\(#function)")
        抽牌堆 = 牌組
    }
    
    func 重置牌組(雜牌 雜牌基礎寶可夢數量: Int) {
        重置牌組(
            取得核心牌組().補雜牌(雜牌基礎寶可夢數量, 數量上限: 牌組數量上限)
        )
    }
    
    func 重置牌組(_ 牌組: [寶可夢牌]) {
        self.牌組 = 牌組
    }
    
    func 重置() {
        //debug_msg(self, 1, "\(#function)")
        
        抽牌堆 = 牌組
        
        手牌 = []
        棄牌堆 = []
        
        洗牌()
    }
    
    func 洗牌() {
        //debug_msg(self, 2, "\(#function)")
        抽牌堆.shuffle()
    }
    
    func 準備() {
        //debug_msg(self, 1, "\(#function)")
        
        guard let 基礎寶可夢 = 抽牌堆.抽({
            $0.是基礎寶可夢()
        }) else { fatalError("抽牌堆, 無基礎寶可夢") }
        洗牌()
        
        手牌 += [基礎寶可夢]
        抽牌(數量: 4)
    }
    
    private func 新回合抽牌() {
        //debug_msg(self, 2, "\(#function)")
        
        抽牌(數量: 1)
    }
    
    func 抽牌(數量: Int) {
        //debug_msg(self, 2, "\(#function)", "\(數量)")
        
        手牌 += 抽牌堆.抽(數量: 數量)
    }
    
    func 新回合() {
        //debug_msg(self, 1, "_______________")
        //debug_msg(self, 1, "\(#function), \(遊戲!.目前回合)")
        
        當前回合未使用支援者 = true
        
        新回合抽牌()
        //debug_msg(self, 1, "新回合抽牌後", 牌堆數量資訊())
        出牌階段()
        //debug_msg(self, 1, "出牌後", 牌堆數量資訊())
    }
    
    func 出牌階段() {
        //debug_msg(self, 1, "\(#function)")
        
        var result: Bool = true
        while result {
            result = false
            
            出牌策略.forEach { 策略 in
                result = result || 執行出牌策略(策略)
            }
        }
    }
    
    func 執行出牌策略(_ 策略: 寶可夢出牌策略) -> Bool {
        //debug_msg(self, 2, "\(#function), \(策略.牌.名稱)")
        
        let 執行策略: () -> Bool
        
        if 策略.牌 == .精靈球 {
            執行策略 = 用精靈球如果有
        }
        else if 策略.牌 == .大木博士 {
            執行策略 = 用大木博士如果有
        }
        else if 策略.牌 == .幻之石板 {
            執行策略 = 用幻之石板如果有
        }
        else if 策略.牌 == .紅卡 {
            執行策略 = 用紅卡如果有
        }
        else {
            fatalError("未實現 \(策略.牌.名稱) 使用方式")
        }
        
        if 策略.只出一張 {
            return 執行策略()
        }
        else {
            return 盡可能(執行策略)
        }
    }
    
    func 觸發紅卡效果() {
        抽牌堆 += 手牌
        手牌.removeAll()
        
        洗牌()
        抽牌(數量: 3)
        
        //debug_msg(self, 1, "\(#function)了")
    }
    
    private func 盡可能(_ 用卡: ()->Bool) -> Bool {
        var result: Bool = false
        (0..<同卡上限).forEach { _ in
            result = result || 用卡()
        }
        return result
    }
    
    private func 用紅卡如果有() -> Bool {
        guard 棄牌(.紅卡) else { return false }
        
        對手!.觸發紅卡效果()
        return true
    }
    
    private func 用幻之石板如果有() -> Bool {
        guard 棄牌(.幻之石板) else { return false }
        
        guard let 第一張牌 = 抽牌堆.抽(數量: 1).first else {
            return true
        }
        guard 第一張牌.屬性 == .超, 第一張牌.是寶可夢() else {
            抽牌堆.append(第一張牌)
            return true
        }
        
        手牌 += [第一張牌]
        return true
    }
    
    private func 用精靈球如果有() -> Bool {
        guard 棄牌(.精靈球) else { return false }
        
        guard let 基礎寶可夢 = 抽牌堆.抽({
            $0.是基礎寶可夢()
        }) else { return true }
        洗牌()
        
        手牌 += [基礎寶可夢]
        return true
    }
    
    private func 用大木博士如果有() -> Bool {
        guard 當前回合未使用支援者 else { return false }
        guard 棄牌(.大木博士) else { return false }
        
        當前回合未使用支援者 = false
        抽牌(數量: 2)
        return true
    }
    
    func 棄牌(數量: Int) {
        棄牌堆 += 手牌.抽(數量: 數量)
    }
    
    func 棄牌(_ 牌: 寶可夢牌) -> Bool {
        
        guard let 手牌的牌 = 手牌.抽({$0 == 牌}) else { return false }
        棄牌堆 += [手牌的牌]
        
        //debug_msg(self, 1, "\(#function) 成功, \(牌.名稱)")
        return true
    }
}


//皮卡丘EX[300, 000], 精靈球 > 大木博士
//|  | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 |
//| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
//| 0 | 0.4 | 1.6 | 3.5 | 6.1 | 9.4 | 12.9 | 16.9 | 21.3 | 25.5 | 29.5 | 33.4 | 37.2 | 40.2 |
//| 1 | 13.6 | 24.1 | 34.6 | 44.1 | 52.1 | 58.2 | 62.5 | 65.4 | 66.8 | 66.8 | 66.4 | 65.8 | 64.9 |
//| 2 | 24.3 | 40.7 | 54.8 | 64.9 | 71.6 | 75.3 | 76.9 | 77.5 | 77.1 | 76.3 | 75.5 | 75.0 | 74.3 |
//| 3 | 35.3 | 55.5 | 70.2 | 78.7 | 83.0 | 84.6 | 84.6 | 84.2 | 83.5 | 82.7 | 82.2 | 81.8 | 81.1 |
//| 4 | 47.3 | 69.6 | 82.6 | 88.4 | 90.4 | 90.5 | 90.0 | 89.4 | 88.7 | 88.2 | 87.8 | 87.3 | 86.9 |
//| 5 | 60.0 | 81.4 | 91.3 | 94.4 | 94.8 | 94.4 | 93.9 | 93.4 | 92.9 | 92.6 | 92.2 | 91.9 | 91.6 |
//| 6 | 72.0 | 90.4 | 96.5 | 97.6 | 97.5 | 97.1 | 96.7 | 96.4 | 96.1 | 95.9 | 95.7 | 95.5 | 95.3 |
//| 7 | 83.0 | 96.2 | 99.0 | 99.1 | 99.0 | 98.8 | 98.6 | 98.4 | 98.3 | 98.2 | 98.1 | 98.0 | 97.9 |
//| 8 | 91.9 | 99.1 | 99.8 | 99.8 | 99.8 | 99.7 | 99.7 | 99.6 | 99.6 | 99.6 | 99.5 | 99.5 | 99.5 |
//| 9 | 98.1 | 99.9 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 99.9 | 99.9 | 99.9 | 99.9 | 99.9 |
//| 10 | 99.8 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |
//| 11 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |
//
//皮卡丘EX[300, 000], 大木博士 > 精靈球
//|  | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 |
//| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
//| 0 | 0.4 | 1.5 | 3.5 | 6.1 | 9.2 | 13.0 | 17.1 | 21.1 | 25.4 | 29.6 | 33.5 | 37.2 | 40.2 |
//| 1 | 14.8 | 25.1 | 35.3 | 44.8 | 52.7 | 58.6 | 63.0 | 65.6 | 66.8 | 67.0 | 66.4 | 65.8 | 65.1 |
//| 2 | 25.5 | 41.7 | 55.2 | 65.4 | 71.9 | 75.5 | 77.3 | 77.5 | 77.1 | 76.3 | 75.5 | 75.0 | 74.4 |
//| 3 | 36.3 | 56.2 | 70.5 | 79.1 | 83.3 | 84.7 | 84.8 | 84.3 | 83.6 | 82.8 | 82.1 | 81.7 | 81.2 |
//| 4 | 48.3 | 70.0 | 82.8 | 88.7 | 90.6 | 90.6 | 90.1 | 89.5 | 88.8 | 88.2 | 87.6 | 87.3 | 86.9 |
//| 5 | 60.6 | 81.8 | 91.3 | 94.5 | 95.0 | 94.4 | 93.9 | 93.5 | 93.0 | 92.6 | 92.2 | 92.0 | 91.6 |
//| 6 | 72.7 | 90.6 | 96.4 | 97.6 | 97.5 | 97.1 | 96.8 | 96.5 | 96.2 | 96.0 | 95.7 | 95.5 | 95.3 |
//| 7 | 83.4 | 96.3 | 98.9 | 99.2 | 99.0 | 98.8 | 98.6 | 98.5 | 98.3 | 98.3 | 98.1 | 98.0 | 97.9 |
//| 8 | 92.1 | 99.1 | 99.8 | 99.8 | 99.8 | 99.7 | 99.7 | 99.6 | 99.6 | 99.6 | 99.5 | 99.5 | 99.5 |
//| 9 | 98.1 | 99.9 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 99.9 | 99.9 | 99.9 | 99.9 | 99.9 |
//| 10 | 99.8 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |
//| 11 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |



//沙奈朵[3000], 精靈球 > 大木博士 > 幻之石板
//|  | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
//| --- | --- | --- | --- | --- | --- | --- | --- |
//| 0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 3 | 48.9 | 47.0 | 43.2 | 42.0 | 39.9 | 40.4 | 39.0 |
//| 4 | 62.5 | 61.4 | 59.5 | 56.2 | 55.6 | 56.8 | 54.6 |
//| 5 | 74.5 | 73.9 | 73.0 | 69.6 | 70.7 | 71.1 | 68.5 |
//| 6 | 84.2 | 84.8 | 84.6 | 83.3 | 82.8 | 83.1 | 81.4 |
//| 7 | 92.3 | 92.2 | 92.2 | 92.0 | 91.1 | 92.0 | 91.3 |
//| 8 | 97.0 | 97.3 | 97.4 | 96.9 | 96.4 | 97.4 | 96.2 |
//| 9 | 99.2 | 99.1 | 99.5 | 99.2 | 99.2 | 99.4 | 99.0 |
//| 10 | 99.8 | 99.9 | 99.9 | 99.8 | 99.9 | 99.9 | 99.8 |
//| 11 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |
//| 12 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |
//
//沙奈朵[3000], 精靈球 > 幻之石板 > 大木博士
//|  | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
//| --- | --- | --- | --- | --- | --- | --- | --- |
//| 0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 3 | 48.8 | 46.4 | 41.0 | 41.8 | 40.5 | 37.9 | 39.3 |
//| 4 | 62.7 | 61.1 | 56.3 | 57.4 | 56.5 | 54.2 | 54.7 |
//| 5 | 75.4 | 74.0 | 71.3 | 71.2 | 69.4 | 69.1 | 68.5 |
//| 6 | 85.9 | 84.4 | 83.6 | 83.0 | 81.6 | 82.0 | 81.3 |
//| 7 | 92.9 | 92.6 | 91.9 | 90.5 | 91.5 | 91.1 | 90.6 |
//| 8 | 97.3 | 96.8 | 96.9 | 95.8 | 96.8 | 96.5 | 96.6 |
//| 9 | 99.3 | 99.1 | 99.2 | 99.2 | 99.2 | 99.1 | 98.8 |
//| 10 | 99.9 | 99.8 | 99.9 | 99.8 | 99.9 | 99.8 | 99.8 |
//| 11 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |
//
//沙奈朵[3000], 大木博士 > 精靈球 > 幻之石板
//|  | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
//| --- | --- | --- | --- | --- | --- | --- | --- |
//| 0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 3 | 46.6 | 46.0 | 43.1 | 42.4 | 39.4 | 38.6 | 39.8 |
//| 4 | 62.4 | 59.9 | 57.7 | 57.6 | 54.9 | 55.0 | 55.8 |
//| 5 | 74.7 | 74.1 | 71.1 | 71.8 | 69.9 | 69.7 | 69.3 |
//| 6 | 85.1 | 84.4 | 83.9 | 84.1 | 82.7 | 82.4 | 81.5 |
//| 7 | 92.9 | 92.5 | 92.2 | 91.8 | 91.7 | 91.5 | 90.2 |
//| 8 | 97.0 | 97.2 | 96.9 | 96.8 | 97.0 | 97.0 | 96.1 |
//| 9 | 99.1 | 99.0 | 99.0 | 99.3 | 99.2 | 99.1 | 98.8 |
//| 10 | 99.9 | 99.8 | 99.9 | 99.9 | 99.9 | 99.7 | 99.8 |
//| 11 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 99.9 |
//| 12 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |
//
//沙奈朵[3000], 大木博士 > 幻之石板 > 精靈球
//|  | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
//| --- | --- | --- | --- | --- | --- | --- | --- |
//| 0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 3 | 47.0 | 43.2 | 42.2 | 41.8 | 39.0 | 39.2 | 37.4 |
//| 4 | 63.4 | 58.3 | 58.0 | 56.9 | 54.1 | 53.9 | 53.1 |
//| 5 | 75.2 | 71.5 | 71.0 | 70.0 | 68.3 | 68.4 | 67.6 |
//| 6 | 85.5 | 83.4 | 81.4 | 83.0 | 81.0 | 80.6 | 81.1 |
//| 7 | 93.0 | 91.7 | 91.5 | 91.3 | 90.3 | 90.6 | 90.7 |
//| 8 | 97.4 | 96.6 | 96.5 | 96.6 | 96.0 | 96.4 | 96.4 |
//| 9 | 99.2 | 99.1 | 99.1 | 99.1 | 99.0 | 98.7 | 98.9 |
//| 10 | 99.9 | 99.9 | 99.9 | 99.9 | 99.8 | 99.8 | 99.9 |
//| 11 | 100.0 | 100.0 | 99.9 | 100.0 | 100.0 | 100.0 | 100.0 |
//| 12 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |
//
//沙奈朵[3000], 幻之石板 > 精靈球 > 大木博士
//|  | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
//| --- | --- | --- | --- | --- | --- | --- | --- |
//| 0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 3 | 47.9 | 44.8 | 43.4 | 39.1 | 41.3 | 40.8 | 37.9 |
//| 4 | 61.9 | 59.2 | 59.2 | 54.5 | 56.9 | 56.3 | 52.7 |
//| 5 | 74.8 | 72.2 | 72.4 | 69.0 | 70.3 | 70.7 | 66.8 |
//| 6 | 85.9 | 83.7 | 84.2 | 82.0 | 82.2 | 82.8 | 79.6 |
//| 7 | 92.8 | 92.0 | 92.0 | 91.0 | 90.9 | 91.7 | 90.4 |
//| 8 | 97.3 | 96.8 | 97.4 | 96.3 | 96.3 | 96.5 | 95.9 |
//| 9 | 99.0 | 99.0 | 99.3 | 99.1 | 98.9 | 98.9 | 98.8 |
//| 10 | 99.8 | 99.9 | 99.8 | 99.8 | 99.8 | 99.8 | 99.8 |
//| 11 | 100.0 | 100.0 | 99.9 | 100.0 | 100.0 | 100.0 | 100.0 |
//| 12 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |
//
//沙奈朵[3000], 幻之石板 > 大木博士 > 精靈球
//|  | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
//| --- | --- | --- | --- | --- | --- | --- | --- |
//| 0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 3 | 47.3 | 46.3 | 43.3 | 41.2 | 40.4 | 40.0 | 39.2 |
//| 4 | 61.2 | 60.7 | 58.0 | 56.8 | 55.5 | 54.3 | 54.6 |
//| 5 | 73.3 | 73.2 | 72.8 | 70.5 | 69.2 | 68.8 | 68.7 |
//| 6 | 84.6 | 84.2 | 84.0 | 83.0 | 81.0 | 80.8 | 81.2 |
//| 7 | 92.3 | 91.9 | 92.0 | 91.6 | 90.4 | 90.3 | 90.2 |
//| 8 | 96.4 | 96.9 | 97.1 | 96.9 | 96.2 | 96.5 | 96.0 |
//| 9 | 98.9 | 99.0 | 99.2 | 99.3 | 98.5 | 99.0 | 98.8 |
//| 10 | 99.9 | 99.8 | 99.9 | 99.8 | 99.8 | 99.8 | 99.8 |
//| 11 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |
//| 12 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |


//沙奈朵[100,000], 大木博士 > 精靈球
//|  | 2 | 3 | 4 | 5 | 6 |
//| --- | --- | --- | --- | --- | --- |
//| 0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 3 | 39.5 | 37.2 | 35.3 | 33.7 | 32.4 |
//| 4 | 52.7 | 50.6 | 48.9 | 47.5 | 46.1 |
//| 5 | 65.4 | 63.7 | 62.1 | 60.6 | 59.5 |
//| 6 | 76.8 | 75.7 | 74.5 | 73.3 | 72.3 |
//| 7 | 86.2 | 85.7 | 84.9 | 84.3 | 83.5 |
//| 8 | 93.2 | 93.2 | 93.0 | 92.6 | 92.2 |
//| 9 | 97.5 | 97.6 | 97.6 | 97.6 | 97.4 |
//| 10 | 99.4 | 99.5 | 99.5 | 99.5 | 99.4 |
//| 11 | 99.9 | 99.9 | 99.9 | 100.0 | 99.9 |
//| 12 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |

//寶石海星[100,000], 大木博士 > 精靈球
//|  | 2 | 3 | 4 | 5 | 6 |
//| --- | --- | --- | --- | --- | --- |
//| 0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |
//| 2 | 56.5 | 53.4 | 50.8 | 48.4 | 47.1 |
//| 3 | 67.3 | 65.0 | 62.8 | 60.6 | 59.4 |
//| 4 | 76.4 | 74.8 | 72.8 | 71.2 | 69.9 |
//| 5 | 84.1 | 83.1 | 81.7 | 80.3 | 79.4 |
//| 6 | 90.4 | 89.8 | 89.0 | 88.0 | 87.4 |
//| 7 | 94.9 | 94.7 | 94.3 | 93.9 | 93.5 |
//| 8 | 98.1 | 98.0 | 97.9 | 97.9 | 97.7 |
//| 9 | 99.5 | 99.6 | 99.6 | 99.5 | 99.4 |
//| 10 | 99.9 | 99.9 | 100.0 | 100.0 | 99.9 |
//| 11 | 100.0 | 100.0 | 100.0 | 100.0 | 100.0 |
