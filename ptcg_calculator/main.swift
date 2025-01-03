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
//let debug_flags = [false, true, true]
func debug_msg(_ 玩家: 寶可夢玩家, _ flagIndex: Int, _ array: String...) {
    guard debug_flags[safe: flagIndex] == true else { return }
    print("\(玩家.先手玩家 ? "先手" : "後手") : " + array.joined(separator: ", "))
}

func main() {
//    for 回合 in 2 ... 10 {
//        let result = MathCombination().drawKeyCard(19, keyCardCount: 2, drawCardCount: 5 - 1 + 回合)
//
//        print("回合\(回合): " + (result * 100).toDotString(1))
//    }
    
    //let simpleModel = 模擬單回機率(); simpleModel.loop(300_000, 抽牌數: 6, 牌組數量上限: 19)
    
    //let model = 模擬抽皮卡丘EX()
//    let model = 模擬抽寶石海星()
//    model.loop(10_000)
    //model.loop(1)
    
    實體測試者.執行所有測試()
}
main()

extension Double {
    func 小數點後(_ 位數: Int) -> String {
        guard 位數 > 0 else { return String(self) }
        
        let formatTxt = "%.\(位數)f"
        return .init(format: formatTxt, self)
    }
}

class 回合統計表 {
    var 雜牌基礎寶可夢數量範圍 = 1...2
    private var 回合範圍: ClosedRange<Int> = 0 ... 20
    private var 目前雜牌基礎寶可夢數量: Int = 0
    private var 測試次數整數 = 0
    private var 測試次數 = Double(0)
    
    private var 達成回合數: [[Int]] = []
    
    func 重置牌組計算範圍(_ 玩家: 寶可夢玩家, 最低 最低雜牌基礎寶可夢數量: Int) -> ClosedRange<Int> {
        玩家.重置牌組(玩家.預設牌組())
        玩家.重置()
        let 雜牌數量 = 玩家.抽牌堆.filter({$0.是雜牌()}).count
        let 最低雜牌基礎寶可夢數量 = min(max(最低雜牌基礎寶可夢數量, 0), 雜牌數量)
        let 雜牌基礎寶可夢數量範圍 = 最低雜牌基礎寶可夢數量 ... 雜牌數量
        
        return 雜牌基礎寶可夢數量範圍
    }
    
    func 重置(_ 測試次數: Int, 範圍 雜牌基礎寶可夢數量範圍: ClosedRange<Int>, 回合數上限: Int) {
        self.測試次數整數 = 測試次數
        self.測試次數 = Double(測試次數)
        self.雜牌基礎寶可夢數量範圍 = 雜牌基礎寶可夢數量範圍
        self.回合範圍 = 0 ... 回合數上限
        
        let empty: [Int] = Array(repeating: 0, count: 回合數上限 + 1)
        達成回合數 = Array(repeating: empty, count: 雜牌基礎寶可夢數量範圍.upperBound + 1)
    }
    
    func 設定(數量 目前雜牌基礎寶可夢數量: Int) {
        self.目前雜牌基礎寶可夢數量 = 目前雜牌基礎寶可夢數量
    }
    
    func 加次數(_ 回合: Int, 次數: Int = 1) {
        達成回合數[目前雜牌基礎寶可夢數量][回合] += 次數
    }
    
    func 顯示結果() {
        func 單項結果(_ 滿場回合數: [Int]) -> [String] {
            滿場回合數.enumerated().map({ 回合, 次數 in
                let probability = (Double(次數) / self.測試次數 * 100).小數點後(1)
                return "\(probability)"
            })
        }
        
        var array: [[String]] = []
        let range = 雜牌基礎寶可夢數量範圍
        
        //加總
        for 基礎寶可夢數量 in range {
            for 回合 in 1 ... 回合範圍.upperBound {
                達成回合數[基礎寶可夢數量][回合] += 達成回合數[基礎寶可夢數量][回合 - 1]
            }
        }
        
        //去尾
        let 全百分百回合 = Array(回合範圍).firstIndex(where: { 回合 in
            for 基礎寶可夢數量 in range {
                if 達成回合數[基礎寶可夢數量][回合] < 測試次數整數 { return false }
            }
            return true
        }) ?? (回合範圍.count - 1)
        
        //製表
        for 基礎寶可夢數量 in range {
            let 單項去尾結果 = 單項結果(達成回合數[基礎寶可夢數量]).prefix(全百分百回合 + 1)
            array.append(Array(單項去尾結果))
        }
        
        //旋轉
        array = array.getGridArray(isRotate: true)
        
        //左標題
        for (index, element) in array.enumerated() {
            array[index] = ["\(index)"] + element
        }
        
        //上標題
        let title = [""] + range.map({String($0)})
        array.insert(title, at: 0)
        
        //print(array.reduce("", {$0 + "\n" + $1.joined(separator: ",")}))
        print(array.matterMostOutput())
    }
}

class 模擬單回機率: 寶可夢TCG控制器 {
    typealias 目前測試玩家 = 噴火龍玩家
    let 遊戲: 寶可夢TCG = .init(所有玩家: [目前測試玩家()])
    private var 抽牌數: Int = 5
    private var 玩家: 目前測試玩家 {遊戲.所有玩家.first as! 目前測試玩家}
    
    private let 統計表 = 回合統計表()
    
    func 回合結束(_ 玩家: 寶可夢玩家) {}
    
    func 是否遊戲結束() -> Bool {
        if 遊戲.目前回合 > 0 { return true }
        return 玩家.手牌.有({$0 == .噴火龍EX})
    }
    
    func 遊戲結束() {
        統計表.加次數(遊戲.目前回合)
    }
    
    private func 測試() {
        遊戲.重置()
        玩家.抽牌(數量: 抽牌數)
        //遊戲.準備()
        if 是否遊戲結束() {
            遊戲結束()
            return
        }
        遊戲.開始()
    }
    
    func loop(_ times: Int, 抽牌數: Int, 牌組數量上限: Int) {
        self.遊戲.控制器 = self
        self.抽牌數 = 抽牌數
        self.遊戲.牌組數量上限 = 牌組數量上限
        
        _ = 統計表.重置牌組計算範圍(玩家, 最低: 0)
        let 雜牌基礎寶可夢數量範圍 = 0 ... 0
        
        統計表.重置(times, 範圍: 雜牌基礎寶可夢數量範圍, 回合數上限: 1)
        
        for 雜牌基礎寶可夢數量 in 雜牌基礎寶可夢數量範圍 {
            統計表.設定(數量: 雜牌基礎寶可夢數量)
            for _ in 0 ..< times {
                測試()
            }
        }
        
        統計表.顯示結果()
    }
}

class 模擬抽寶石海星: 寶可夢TCG控制器 {
    private typealias 目前測試玩家 = 寶石海星玩家
    private let 遊戲: 寶可夢TCG = .init(所有玩家: [目前測試玩家()])
    private var 玩家: 目前測試玩家 {遊戲.所有玩家.first as! 目前測試玩家}
    
    private let 統計表 = 回合統計表()
    
    func 回合結束(_ 玩家: 寶可夢玩家) {}
    
    func 是否遊戲結束() -> Bool {
        return 玩家.是否已放置關鍵牌()
    }
    
    func 遊戲結束() {
        統計表.加次數(遊戲.目前回合)
    }
    
    private func 測試() {
        遊戲.重置()
        遊戲.準備()
        if 是否遊戲結束() {
            遊戲結束()
            return
        }
        遊戲.開始()
    }
    
    func loop(_ 測試次數: Int) {
        self.遊戲.控制器 = self
        let 雜牌基礎寶可夢數量範圍 = 統計表.重置牌組計算範圍(玩家, 最低: 0)
        
        寶可夢出牌策略.測試所有順序(玩家) {
            統計表.重置(測試次數, 範圍: 雜牌基礎寶可夢數量範圍, 回合數上限: 遊戲.牌組數量上限)
            
            for 雜牌基礎寶可夢數量 in 雜牌基礎寶可夢數量範圍 {
                統計表.設定(數量: 雜牌基礎寶可夢數量)
                玩家.重置牌組(雜牌: 雜牌基礎寶可夢數量)
                for _ in 0 ..< 測試次數 {
                    測試()
                }
            }
            
            統計表.顯示結果()
        }
    }
}

class 模擬抽皮卡丘EX: 寶可夢TCG控制器 {
    typealias 目前測試玩家 = 皮卡丘EX玩家
    let 遊戲: 寶可夢TCG = .init(所有玩家: [目前測試玩家()])
    private var 皮卡丘玩家: 目前測試玩家 {遊戲.所有玩家.first as! 目前測試玩家}
    
    private let 統計表 = 回合統計表()
    
    func 回合結束(_ 玩家: 寶可夢玩家) {}
    func 是否遊戲結束() -> Bool {
        let 基礎寶可夢充足 = 皮卡丘玩家.手牌.有幾張({$0.是基礎寶可夢()}) >= 4
        let 有皮卡丘 = 皮卡丘玩家.手牌.有({$0 == .皮卡丘EX})
        return 有皮卡丘 && 基礎寶可夢充足
    }
    
    func 遊戲結束() {
        統計表.加次數(遊戲.目前回合)
    }
    
    private func 測試() {
        遊戲.重置()
        遊戲.準備()
        if 是否遊戲結束() {
            遊戲結束()
            return
        }
        遊戲.開始()
    }
    
    
    func loop(_ times: Int) {
        self.遊戲.控制器 = self
        
        let 雜牌基礎寶可夢數量範圍 = 統計表.重置牌組計算範圍(皮卡丘玩家, 最低: 2)
        寶可夢出牌策略.測試所有順序(皮卡丘玩家) {
            統計表.重置(times, 範圍: 雜牌基礎寶可夢數量範圍, 回合數上限: 遊戲.牌組數量上限)
            
            for 雜牌基礎寶可夢數量 in 雜牌基礎寶可夢數量範圍 {
                統計表.設定(數量: 雜牌基礎寶可夢數量)
                皮卡丘玩家.重置牌組(雜牌: 雜牌基礎寶可夢數量)
                for _ in 0 ..< times {
                    測試()
                }
            }
            
            統計表.顯示結果()
        }
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
    
    var 目前回合: Int = 0
    
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
        目前回合 = 1
        所有玩家[0].新回合()
    }
    
    private func 詢問遊戲結束() -> Bool {
        guard let 控制器 else { return 目前回合 > 20 }
        return 控制器.是否遊戲結束()
    }
    
    func 玩家回合結束(_ 玩家: 寶可夢玩家) {
        debug_msg(玩家, 2, "\(#function)")
        
        控制器?.回合結束(玩家)
        
        guard !詢問遊戲結束() else {
            debug_msg(玩家, 1, "遊戲結束")
            
            控制器?.遊戲結束()
            return
        }
        
        let 新回合玩家 = 玩家.先手玩家 ? 1 : 0
        if !玩家.先手玩家 { 目前回合 += 1 }
        所有玩家[新回合玩家].新回合()
    }
    
    func 玩家行動(callback: (寶可夢玩家)->Void) {
        self.所有玩家.forEach {callback($0)}
    }
}

struct 寶可夢出牌策略: Hashable, Equatable {
    let 牌: 寶可夢牌
    let 只出一張: Bool
    
    static func 測試所有順序(_ 玩家: 寶可夢玩家, callback: ()->Void) {
        let 玩家出牌策略 = 玩家.出牌策略
        guard !玩家出牌策略.isEmpty else {
            callback()
            return
        }
        
        let 所有順序 = 玩家出牌策略.所有順序()
        for 出牌策略 in 所有順序 {
            玩家.出牌策略 = 出牌策略
            print(出牌策略.map({$0.牌.名稱}).joined(separator: " > "))
            
            callback()
        }
        
        玩家.出牌策略 = 玩家出牌策略
    }
}
extension Array where Element == 寶可夢出牌策略 {
    func 所有順序() -> [[寶可夢出牌策略]] {
        return AllCasesTester.permutations(of: self)
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
    
    func 調整牌組(_ 卡: 寶可夢牌, 加入 數量: Int, 數量上限: Int) -> [寶可夢牌] {
        var cards: [寶可夢牌] = self
        
        let maxCount = 數量上限 - cards.count
        let 數量 = Swift.min(maxCount, 數量)
        cards += .init(牌: 卡, 數量: 數量)
        return cards
    }
    
    func 調整雜牌(_ 雜牌基礎寶可夢數量: Int, 數量上限: Int) -> [寶可夢牌] {
        var cards = 調整牌組(.雜牌基礎寶可夢, 加入: 雜牌基礎寶可夢數量, 數量上限: 數量上限)
        cards.補雜牌(數量上限)
        return cards
    }
    
    mutating func 補雜牌(_ 數量上限: Int) {
        let 雜牌數 = 數量上限 - count
        guard 雜牌數 > 0 else { return }
        
        append(contentsOf: Array<寶可夢牌>(牌: .雜牌, 數量: 雜牌數))
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

class 陪練玩家: 寶可夢玩家 {
    static func 後手陪練玩家() -> 陪練玩家 {
        let 玩家 = 陪練玩家()
        玩家.先手玩家 = false
        return 玩家
    }
    
    override func 新回合() {
        self.遊戲?.玩家回合結束(self)
    }
}

class 皮卡丘EX玩家: 寶可夢玩家 {
    override func 取得核心牌組() -> [寶可夢牌] {
        .init(同卡: .皮卡丘EX)
        + .init(牌: .雜牌基礎寶可夢, 數量: 2)
        + .博士與精靈球
    }
}

class 寶石海星玩家: 寶可夢玩家 {
    override func 取得核心牌組() -> [寶可夢牌] {
        .init(同卡: .寶石海星EX)
        + .init(同卡: .海星星)
        + .博士與精靈球
    }
    
    func 是否已放置關鍵牌() -> Bool {
        let 進化寶石海星EX = 棄牌堆.有({$0 == .寶石海星EX})
        return 進化寶石海星EX
    }
    
    override func 出牌階段() {
        super.出牌階段()
        出關鍵牌如果能()
    }
    
    private func 出關鍵牌如果能() {
        debug_msg(self, 1, "\(#function)")
        
        let 上回合有放海星星 = 棄牌堆.有({$0 == .海星星})
        _ = 棄牌(.海星星)
        
        guard 遊戲!.目前為可進化回合() else { return }
        
        guard 上回合有放海星星 else { return }
        _ = 棄牌(.寶石海星EX)
    }
}

class 噴火龍玩家: 寶可夢玩家 {
    override func 取得核心牌組() -> [寶可夢牌] {
        let cards: [寶可夢牌] = .init(同卡: .噴火龍EX)
//        + 寶可夢TCG卡.博士與精靈球
//        + .init(同卡: .雜牌基礎寶可夢)//火焰鳥
        + .init(同卡: .雜牌基礎寶可夢)//小火龍
        + .init(同卡: .雜牌1階寶可夢)//火恐龍
        return cards
    }
}

class 寶可夢玩家 {
    weak var 遊戲: 寶可夢TCG?
    var 先手玩家: Bool = true
    var 牌組數量上限: Int {遊戲?.牌組數量上限 ?? 寶可夢TCG.預設牌組數量上限}
    var 同卡上限: Int {遊戲?.同卡上限 ?? 寶可夢TCG.預設同卡上限}
    
    var 出牌策略: [寶可夢出牌策略] = [
        .init(牌: .精靈球, 只出一張: false),
        .init(牌: .大木博士, 只出一張: true),
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
        取得核心牌組().調整雜牌(0, 數量上限: 牌組數量上限)
    }
    
    func 測試用重置抽牌堆(_ 牌組: [寶可夢牌]) {
        抽牌堆 = 牌組
    }
    
    func 重置牌組(雜牌 雜牌基礎寶可夢數量: Int) {
        重置牌組(
            取得核心牌組().調整雜牌(雜牌基礎寶可夢數量, 數量上限: 牌組數量上限)
        )
    }
    
    func 重置牌組(_ 牌組: [寶可夢牌]) {
        self.牌組 = 牌組
    }
    
    func 重置() {
        debug_msg(self, 1, "\(#function)")
        
        抽牌堆 = 牌組
        
        手牌 = []
        棄牌堆 = []
        
        洗牌()
    }
    
    func 洗牌() {
        debug_msg(self, 2, "\(#function)")
        抽牌堆.shuffle()
    }
    
    func 準備() {
        debug_msg(self, 1, "\(#function)")
        
        guard let 基礎寶可夢 = 抽牌堆.抽({
            $0.是基礎寶可夢()
        }) else { fatalError("抽牌堆, 無基礎寶可夢") }
        洗牌()
        
        手牌 += [基礎寶可夢]
        抽牌(數量: 4)
    }
    
    private func 新回合抽牌() {
        debug_msg(self, 2, "\(#function)")
        
        抽牌(數量: 1)
    }
    
    func 抽牌(數量: Int) {
        debug_msg(self, 2, "\(#function)", "\(數量)")
        
        手牌 += 抽牌堆.抽(數量: 數量)
    }
    
    func 新回合() {
        debug_msg(self, 1, "_______________")
        debug_msg(self, 1, "\(#function), \(遊戲!.目前回合)")
        
        當前回合未使用支援者 = true
        
        新回合抽牌()
        debug_msg(self, 1, "新回合抽牌後", 牌堆數量資訊())
        出牌階段()
        debug_msg(self, 1, "出牌後", 牌堆數量資訊())
        
        self.遊戲?.玩家回合結束(self)
    }
    
    func 出牌階段() {
        debug_msg(self, 1, "\(#function)")
        
        var result: Bool = true
        while result {
            result = false
            
            出牌策略.forEach { 策略 in
                result = result || 執行出牌策略(策略)
            }
        }
    }
    
    func 執行出牌策略(_ 策略: 寶可夢出牌策略) -> Bool {
        debug_msg(self, 2, "\(#function), \(策略.牌.名稱)")
        
        let 執行策略: () -> Bool
        
        if 策略.牌 == .精靈球 {
            執行策略 = 用精靈球如果有
        }
        else if 策略.牌 == .大木博士 {
            執行策略 = 用大木博士如果有
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
    
    private func 盡可能(_ 用卡: ()->Bool) -> Bool {
        var result: Bool = false
        (0..<同卡上限).forEach { _ in
            result = result || 用卡()
        }
        return result
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
        //debug_msg(self, 2, "\(#function), \(牌.名稱)")
        
        guard let 手牌的牌 = 手牌.抽({$0 == 牌}) else { return false }
        debug_msg(self, 1, "\(#function) 成功, \(牌.名稱)")
        
        棄牌堆 += [手牌的牌]
        return true
    }
}
