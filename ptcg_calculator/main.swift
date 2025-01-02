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

main()

func main() {
    let model = HasKeyCard()
    
    func testResetCard(_ totalCount: Int) {
        model.resetCard(totalCount, keyCardCount: 2)
        assert(model.cards.filter({$0 == model.keyCard}).count == 2)
        assert(model.cards.filter({$0 != model.keyCard}).count == totalCount - 2)
    }
    
    func testShuffle() {
        model.resetCard(5, keyCardCount: 2)
        
        let result = model.shuffleAndDraw(2) ? "hit" : "miss"
        print("\(result), \(model.cards)")
    }
    
    for i in 2 ... 10 {
        testResetCard(i)
    }
    
//    for _ in 1 ... 10 {
//        testShuffle()
//    }
    print("testing end")
    
    let model2 = 模擬抽皮卡丘EX()
    //let model2 = 模擬抽寶石海星()
    model2.loopTest(10000)
}

extension Double {
    func 小數點後(_ 位數: Int) -> String {
        guard 位數 > 0 else { return String(self) }
        
        let formatTxt = "%.\(位數)f"
        return .init(format: formatTxt, self)
    }
}

class 回合統計表 {
    var 雜牌基礎寶可夢數量範圍 = 1...2
    private var 目前雜牌基礎寶可夢數量: Int = 0
    private var 測試次數 = Double(0)
    
    private var 達成回合數: [[Int]] = []
    
    func 重置(_ 測試次數: Int, 範圍 雜牌基礎寶可夢數量範圍: ClosedRange<Int>, 牌組數量上限: Int) {
        self.測試次數 = Double(測試次數)
        self.雜牌基礎寶可夢數量範圍 = 雜牌基礎寶可夢數量範圍
        
        let empty: [Int] = Array(repeating: 0, count: 牌組數量上限 + 1)
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
        for 基礎寶可夢數量 in range {
            for 回合 in 1 ..< 達成回合數[基礎寶可夢數量].count {
                達成回合數[基礎寶可夢數量][回合] += 達成回合數[基礎寶可夢數量][回合 - 1]
            }
            array.append(單項結果(達成回合數[基礎寶可夢數量]))
        }
        
        array = array.getGridArray(isRotate: true)
        for (index, element) in array.enumerated() {
            array[index] = ["\(index)"] + element
        }
        
        let title = [""] + range.map({String($0)})
        array.insert(title, at: 0)
        
        print(array.reduce("", {$0 + "\n" + $1.joined(separator: ",")}))
        //print(array.matterMostOutput())
    }
}

class 模擬抽寶石海星: 寶可夢TCG控制器 {
    typealias 目前測試玩家 = 寶石海星玩家
    let 遊戲: 寶可夢TCG = .init(所有玩家: [目前測試玩家()])
    private var 玩家: 目前測試玩家 {遊戲.所有玩家.first as! 目前測試玩家}
    
    private let 統計表 = 回合統計表()
    
    func 回合結束(_ 玩家: 寶可夢玩家) {
        self.玩家.回合結束放關鍵牌如果能()
    }
    
    func 是否遊戲結束() -> Bool {
        let 進化寶石海星EX = 玩家.棄牌堆.有({$0 == .寶石海星EX})
        return 進化寶石海星EX
    }
    
    func 遊戲結束() {
        統計表.加次數(遊戲.目前回合)
    }
    
    func 測試(_ 雜牌基礎寶可夢數量: Int) {
        玩家.調整基礎寶可夢(雜牌基礎寶可夢數量)
        
        遊戲.重置()
        遊戲.準備()
        if 是否遊戲結束() {
            遊戲結束()
            return
        }
        遊戲.開始()
    }
    
    
    func loopTest(_ times: Int) {
        self.遊戲.控制器 = self
        
        玩家.調整基礎寶可夢(2)
        遊戲.重置()
        let 雜牌數量 = 玩家.抽牌堆.filter({$0.是雜牌()}).count
        let 雜牌基礎寶可夢數量範圍 = 0 ... 雜牌數量
        
        統計表.重置(times, 範圍: 雜牌基礎寶可夢數量範圍, 牌組數量上限: 遊戲.牌組數量上限)
        
        for 雜牌基礎寶可夢數量 in 雜牌基礎寶可夢數量範圍 {
            統計表.設定(數量: 雜牌基礎寶可夢數量)
            玩家.調整基礎寶可夢(雜牌基礎寶可夢數量)
            for _ in 0 ..< times {
                測試(雜牌基礎寶可夢數量)
            }
        }
        
        統計表.顯示結果()
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
    
    func 測試皮卡丘滿場回合數(_ 雜牌基礎寶可夢數量: Int) {
        皮卡丘玩家.調整基礎寶可夢(雜牌基礎寶可夢數量)
        
        遊戲.重置()
        遊戲.準備()
        if 是否遊戲結束() {
            遊戲結束()
            return
        }
        遊戲.開始()
    }
    
    
    func loopTest(_ times: Int) {
        self.遊戲.控制器 = self
        
        皮卡丘玩家.調整基礎寶可夢(2)
        遊戲.重置()
        let 雜牌數量 = 皮卡丘玩家.抽牌堆.filter({$0.是雜牌()}).count
        let 雜牌基礎寶可夢數量範圍 = 2 ... 雜牌數量
        
        統計表.重置(times, 範圍: 雜牌基礎寶可夢數量範圍, 牌組數量上限: 遊戲.牌組數量上限)
        
        for 雜牌基礎寶可夢數量 in 雜牌基礎寶可夢數量範圍 {
            統計表.設定(數量: 雜牌基礎寶可夢數量)
            皮卡丘玩家.調整基礎寶可夢(雜牌基礎寶可夢數量)
            for _ in 0 ..< times {
                測試皮卡丘滿場回合數(雜牌基礎寶可夢數量)
            }
        }
        
        統計表.顯示結果()
    }
}

class 模擬抽噴火龍EX {
    let 遊戲: 寶可夢TCG = .init(所有玩家: [噴火龍EX玩家()])
    
    func 關鍵牌測試(_ 數量: Int) -> Bool {
        let 玩家 = 遊戲.所有玩家[0]
        玩家.重置()
        
        玩家.抽牌堆棄牌(數量: 20 - 數量) {$0 != .噴火龍EX}
        玩家.洗牌()
        
        玩家.抽卡(數量: 4)
        
        //玩家.顯示牌堆資訊()//debug
        
        return 玩家.手牌.first(where: {$0 == .噴火龍EX}) != nil
    }
    
    func loopTest(_ times: Int, 數量: Int) -> Double {
        let count = (0..<times).reduce(0, {
            sum, index in
            return sum + (self.關鍵牌測試(數量) ? 1 : 0)
        })
        print("\(count) / \(times)")//debug
        return Double(count) / Double(times)
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
    
    func 重新開始() {
        重置()
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
        控制器?.回合結束(玩家)
        
        if !玩家.先手玩家 {
            guard !詢問遊戲結束() else {
                控制器?.遊戲結束()
                return
            }
            目前回合 += 1
        }
        let 新回合玩家 = 玩家.先手玩家 ? 1 : 0
        所有玩家[新回合玩家].新回合()
        
    }
    
    func 玩家行動(callback: (寶可夢玩家)->Void) {
        self.所有玩家.forEach {callback($0)}
    }
}

struct 寶可夢出牌策略: Hashable, Equatable {
    let 卡: 寶可夢卡
    let 只出一張: Bool
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
struct 寶可夢卡: Hashable, Equatable {
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
extension 寶可夢卡 {
    static let 博士與精靈球: [寶可夢卡] = .init(同卡: .大木博士) + .init(同卡: .精靈球)
    
    static let 雜牌基礎寶可夢: 寶可夢卡 = .init(
        名稱: "雜牌基礎寶可夢",
        類型: .基礎,
        屬性: nil
    )
    static let 雜牌1階寶可夢: 寶可夢卡 = .init(
        名稱: "雜牌基礎寶可夢",
        類型: .一階,
        屬性: nil
    )
    static let 拉魯拉絲: 寶可夢卡 = .init(
        名稱: "拉魯拉絲",//Ralts
        類型: .基礎,
        屬性: .超
    )
    static let 奇魯莉安: 寶可夢卡 = .init(
        名稱: "奇魯莉安",//Kirlia
        類型: .一階,
        屬性: .超
    )
    static let 沙奈朵: 寶可夢卡 = .init(
        名稱: "沙奈朵",//Gardevoir
        類型: .二階,
        屬性: .超
    )
    static let 超夢EX: 寶可夢卡 = .init(
        名稱: "超夢EX",
        類型: .基礎,
        屬性: .超
    )
    static let 皮卡丘EX: 寶可夢卡 = .init(
        名稱: "皮卡丘EX",
        類型: .基礎,
        屬性: .雷
    )
    static let 海星星: 寶可夢卡 = .init(
        名稱: "海星星",
        類型: .基礎,
        屬性: .水
    )
    static let 寶石海星EX: 寶可夢卡 = .init(
        名稱: "寶石海星EX",
        類型: .一階,
        屬性: .水
    )
    static let 噴火龍EX: 寶可夢卡 = .init(
        名稱: "噴火龍EX",
        類型: .二階,
        屬性: .火
    )
    static let 雜牌: 寶可夢卡 = .init(
        名稱: "雜牌",
        類型: .物品,
        屬性: nil
    )
    static let 精靈球: 寶可夢卡 = .init(
        名稱: "精靈球",
        類型: .物品,
        屬性: nil
    )
    static let 幻之石板: 寶可夢卡 = .init(
        名稱: "幻之石板",
        類型: .物品,
        屬性: nil
    )
    static let 大木博士: 寶可夢卡 = .init(
        名稱: "大木博士",
        類型: .支援者,
        屬性: nil
    )
}
extension Array where Element == 寶可夢卡 {
    init(卡: 寶可夢卡, 數量: Int) {
        self = Array(repeating: 卡, count: 數量)
    }
    
    init(同卡: 寶可夢卡, 同卡上限: Int = 寶可夢TCG.預設同卡上限) {
        self = .init(卡: 同卡, 數量: 同卡上限)
    }
    
    init(雜牌數: Int, 雜牌基礎寶可夢數: Int) {
        self = .init(卡: .雜牌, 數量: 雜牌數) + .init(卡: .雜牌基礎寶可夢, 數量: 雜牌基礎寶可夢數)
    }
    
    func 有(_ 條件: (寶可夢卡)->Bool) -> Bool {
        self.first(where: 條件) != nil
    }
    
    func 有幾張(_ 條件: (寶可夢卡)->Bool) -> Int {
        self.filter(條件).count
    }
    
    mutating func 補雜牌(_ 數量上限: Int) {
        let 雜牌數 = 數量上限 - count
        guard 雜牌數 > 0 else { return }
        
        append(contentsOf: Array<寶可夢卡>(卡: .雜牌, 數量: 雜牌數))
    }
    
    mutating func 抽(_ 條件: (寶可夢卡)->Bool) -> 寶可夢卡? {
        guard let index = self.firstIndex(where: 條件) else { return nil }
        defer { self.remove(at: index) }
        return self[index]
    }
    
    mutating func 抽(數量: Int) -> [寶可夢卡] {
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
    private func 調整牌組(_ 雜牌基礎寶可夢數量: Int) -> [寶可夢卡] {
        var cards: [寶可夢卡] = .init(同卡: .皮卡丘EX) + 寶可夢卡.博士與精靈球
        cards = 調整牌組(cards, 卡: .雜牌基礎寶可夢, 加入: 雜牌基礎寶可夢數量)
        cards.補雜牌(牌組數量上限)
        return cards
    }
    
    override func 建立牌組() -> [寶可夢卡] {
        return 調整牌組(10)
    }
    
    func 調整基礎寶可夢(_ 雜牌基礎寶可夢數量: Int) {
        重置牌組(調整牌組(雜牌基礎寶可夢數量))
    }
}

class 寶石海星玩家: 寶可夢玩家 {
    func 回合結束放關鍵牌如果能() {
        let 上回合有放海星星 = 棄牌堆.有({$0 == .海星星})
        _ = 丟手牌(.海星星)
        
        //第1回合不可進化
        guard (遊戲?.目前回合 ?? 1) > 1 else { return }
        
        guard 上回合有放海星星 else { return }
        _ = 丟手牌(.寶石海星EX)
    }
    
    private func 調整牌組(_ 雜牌基礎寶可夢數量: Int) -> [寶可夢卡] {
        var cards: [寶可夢卡] = .init(同卡: .寶石海星EX) + .init(同卡: .海星星) + 寶可夢卡.博士與精靈球
        cards = 調整牌組(cards, 卡: .雜牌基礎寶可夢, 加入: 雜牌基礎寶可夢數量)
        cards.補雜牌(牌組數量上限)
        return cards
    }
    
    override func 建立牌組() -> [寶可夢卡] {
        return 調整牌組(10)
    }
    
    func 調整基礎寶可夢(_ 雜牌基礎寶可夢數量: Int) {
        重置牌組(調整牌組(雜牌基礎寶可夢數量))
    }
}

class 噴火龍EX玩家: 寶可夢玩家 {
    override func 建立牌組() -> [寶可夢卡] {
        var cards: [寶可夢卡] = .init(同卡: .噴火龍EX) //+ 寶可夢TCG卡.博士與精靈球
//        + .init(同卡: .雜牌基礎寶可夢)//火焰鳥
//        + .init(同卡: .雜牌基礎寶可夢)//小火龍
//        + .init(同卡: .雜牌1階寶可夢)//火恐龍
        cards.補雜牌(牌組數量上限)
        return cards
    }
}

class 寶可夢玩家 {
    weak var 遊戲: 寶可夢TCG?
    var 先手玩家: Bool = true
    var 牌組數量上限: Int {遊戲?.牌組數量上限 ?? 寶可夢TCG.預設牌組數量上限}
    var 同卡上限: Int {遊戲?.同卡上限 ?? 寶可夢TCG.預設同卡上限}
    
    var 出牌策略: [寶可夢出牌策略] = [
        .init(卡: .精靈球, 只出一張: false),
        .init(卡: .大木博士, 只出一張: true),
    ]
    
    private lazy var 牌組: [寶可夢卡] = 建立牌組()
    
    private(set) var 手牌: [寶可夢卡] = []
    private(set) var 抽牌堆: [寶可夢卡] = []
    private(set) var 棄牌堆: [寶可夢卡] = []
    
    func 顯示牌堆資訊(_ 牌堆名稱: [KeyPath<寶可夢玩家, [寶可夢卡]>] = [\.手牌, \.抽牌堆, \.棄牌堆]) {
        print("_______________")
        牌堆名稱.forEach {
            let 牌堆 = self[keyPath: $0]
            print("\($0)[\(牌堆.count)]: \(牌堆.map(\.名稱).joined(separator: ", "))")
        }
    }
    
    func 建立牌組() -> [寶可夢卡] {
        var cards = 寶可夢卡.博士與精靈球
        cards = 調整牌組(cards, 卡: .雜牌基礎寶可夢, 加入: 2)
        cards.補雜牌(牌組數量上限)
        return cards
    }
    
    func 調整牌組(_ 牌組: [寶可夢卡], 卡: 寶可夢卡, 加入 數量: Int) -> [寶可夢卡] {
        var cards: [寶可夢卡] = 牌組
        
        let maxCount = (遊戲?.牌組數量上限 ?? 寶可夢TCG.預設牌組數量上限) - cards.count
        let 數量 = min(maxCount, 數量)
        cards += .init(卡: 卡, 數量: 數量)
        return cards
    }
    
    func 重置牌組(_ 牌組: [寶可夢卡]) {
        self.牌組 = 牌組
    }
    
    func 重置() {
        抽牌堆 = 牌組
        
        手牌 = []
        棄牌堆 = []
        
        洗牌()
    }
    
    func 抽牌堆棄牌(數量: Int, 條件: (寶可夢卡)->Bool) {
        var 數量 = 數量
        while 數量 > 0, let 雜牌 = 抽牌堆.抽(條件) {
            棄牌堆 += [雜牌]
            數量 -= 1
        }
    }
    
    func 抽牌堆棄雜牌(數量: Int) {
        抽牌堆棄牌(數量: 數量, 條件: {$0 == .雜牌})
    }
    
    func 洗牌() {
        抽牌堆.shuffle()
    }
    
    func 準備() {
        guard let 基礎寶可夢 = 抽牌堆.抽({
            $0.是基礎寶可夢()
        }) else { fatalError("抽牌堆, 無基礎寶可夢") }
        
        手牌 += [基礎寶可夢]
        抽卡(數量: 4)
    }
    
    private func 新回合抽卡() {
        抽卡(數量: 1)
    }
    
    func 抽卡(數量: Int) {
        手牌 += 抽牌堆.抽(數量: 數量)
    }
    
    func 新回合() {
        新回合抽卡()
        執行目前所有出牌策略()
        
        self.遊戲?.玩家回合結束(self)
    }
    
    func 執行目前所有出牌策略() {
        出牌策略.forEach(執行出牌策略)
    }
    
    private func 執行出牌策略(_ 策略: 寶可夢出牌策略) {
        let 執行策略: () -> Void
        
        if 策略.卡 == .精靈球 {
            執行策略 = 用精靈球如果有
        }
        else if 策略.卡 == .大木博士 {
            執行策略 = 用大木博士如果有
        }
        else {
            fatalError("未實現 \(策略.卡.名稱) 使用方式")
        }
        
        if 策略.只出一張 {
            執行策略()
        }
        else {
            盡可能(執行策略)
        }
    }
    
    private func 盡可能(_ 用卡: ()->Void) {
        (0..<同卡上限).forEach { _ in
            用卡()
        }
    }
    
    private func 用精靈球如果有() {
        guard 丟手牌(.精靈球) else { return }
        
        guard let 基礎寶可夢 = 抽牌堆.抽({
            $0.是基礎寶可夢()
        }) else {return}
        
        手牌 += [基礎寶可夢]
        洗牌()
    }
    
    private func 用大木博士如果有() {
        guard 丟手牌(.大木博士) else { return }
        
        抽卡(數量: 2)
    }
    
    func 丟手牌(_ 卡: 寶可夢卡) -> Bool {
        guard let 手牌的卡 = 手牌.抽({$0 == 卡}) else { return false }
        
        棄牌堆 += [手牌的卡]
        return true
    }
}
