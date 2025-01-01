//
//  main.swift
//  ptcg_calculator
//
//  Created by A on 2025/1/2.
//

import Foundation

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
    
    
    let model2 = 模擬抽噴火龍EX()
    let mathResult = (5...17).map({
        model.resetCard($0)
        let model1Result = model.testShuffleAndDrawProbability(10000, 4).toDotString(4)
        let model2Result = model2.loopTest(10000, 數量: $0).toDotString(4)
        return "\($0) -> \(model.shuffleAndDrawMath(4).toDotString(4)) - \(model1Result) - \(model2Result)"
    }).reversed()
    print(mathResult.joined(separator: "\n"))
    
//    model.printRedCardProbability(50000, deckCardCount: 10, handCardCount: 3, drawCardCount: 3)
//    model.printRedCardProbability(50000, deckCardCount: 10, handCardCount: 3, drawCardCount: 4)
//
//    model.printRedCardProbability(50000, deckCardCount: 10, handCardCount: 4, drawCardCount: 3)
//    model.printRedCardProbability(50000, deckCardCount: 10, handCardCount: 4, drawCardCount: 4)
}

extension Double {
    func toDotString(_ digits: Int) -> String {
        guard digits > 0 else { return String(self) }
        
        let formatTxt = "%.\(digits)f"
        return .init(format: formatTxt, self)
    }
}

class HasKeyCard {
    enum RedCardResult: String, CaseIterable, Hashable {
        case XX, XO, OX, OO
    }
    
    private(set) var cards: [Int] = []
    
    let keyCard: Int = 0
    let elseCard: Int = 1
    
    func resetCard(_ count: Int, keyCardCount: Int = 2) {
        cards = []
        guard count > 0, count >= keyCardCount else { return }
        
        cards = Array(repeating: elseCard, count: count - keyCardCount) +
        Array(repeating: keyCard, count: keyCardCount)
    }
    
    func hasKeyCard(_ handCardCount: Int) -> Bool {
        cards.prefix(handCardCount).contains([keyCard])
    }
    
    func shuffleAndDraw(_ drawCardCount: Int) -> Bool {
        cards.shuffle()
        return hasKeyCard(drawCardCount)
    }
    
    func beforeAndAfterRedCard(_ deckCardCount: Int, handCardCount: Int, drawCardCount: Int, keyCardCount: Int = 2) -> RedCardResult {
        let total = deckCardCount + handCardCount
        resetCard(total, keyCardCount: keyCardCount)
        
        let beforeResult = shuffleAndDraw(handCardCount) ? "O" : "X"
        let afterResult = shuffleAndDraw(drawCardCount) ? "O" : "X"
        
        return .init(rawValue: beforeResult + afterResult)!
    }
    
    func testRedCardResult(_ times: Int, deckCardCount: Int, handCardCount: Int, drawCardCount: Int, keyCardCount: Int = 2) -> [RedCardResult : Int] {
        var result: [RedCardResult : Int] = [:]
        RedCardResult.allCases.forEach { result[$0] = 0 }
        
        for _ in 0 ..< times {
            let oneTimeResult = beforeAndAfterRedCard(deckCardCount, handCardCount: handCardCount, drawCardCount: drawCardCount, keyCardCount: keyCardCount)
            
            result[oneTimeResult] = result[oneTimeResult]! + 1
        }
        
        return result
    }
    
    func printRedCardProbability(_ times: Int, deckCardCount: Int, handCardCount: Int, drawCardCount: Int, keyCardCount: Int = 2) {
        let redCardResult = testRedCardResult(times,
                                              deckCardCount: deckCardCount,
                                              handCardCount: handCardCount,
                                              drawCardCount: drawCardCount,
                                              keyCardCount: keyCardCount)
        func getProbability(_ type: RedCardResult) -> Double {
            Double(redCardResult[type]!) / Double(times)
        }
        print("_______________")
        print("times: \(times), deck: \(deckCardCount), hand: \(handCardCount), draw: \(drawCardCount), key: \(keyCardCount)")
        RedCardResult.allCases.forEach { type in
            let probability = (getProbability(type) * 100).toDotString(2)
            print("\(type.rawValue): \(probability), count: \(redCardResult[type]!)")
        }
    }
    
    func testShuffleAndDrawProbability(_ times: Int, _ drawCardCount: Int, keyCardCount: Int = 2) -> Double {
        let total = cards.count
        let hand = drawCardCount
        let deck = total - hand
        let redCardResult = testRedCardResult(times, deckCardCount: deck, handCardCount: hand, drawCardCount: 1, keyCardCount: keyCardCount)
        
        let hitTimes = redCardResult[.OO]! + redCardResult[.OX]!
        return Double(hitTimes) / Double(times)
    }
    
    func shuffleAndDrawMath(_ drawCardCount: Int, keyCardCount: Int = 2) -> Double {
        let total = cards.count
        return MathCombination().drawKeyCard(total, keyCardCount: keyCardCount, drawCardCount: drawCardCount)
    }
}

class MathCombination {
    func drawKeyCard(_ total: Int, keyCardCount: Int, drawCardCount: Int) -> Double {
        let totalCombinations = combination(total, drawCardCount)
        let noKeyCardCombinations = combination(total - keyCardCount, drawCardCount)
        return 1.0 - (Double(noKeyCardCombinations) / Double(totalCombinations))
    }
    
    func combination(_ n: Int, _ k: Int) -> Int {
        if k > n {
            return 0
        }
        return factorial(n) / (factorial(k) * factorial(n - k))
    }
    
    func factorial(_ n: Int) -> Int {
        return n == 0 ? 1 : (1...n).reduce(1, *)
    }
}


extension Double {
    func 小數點後(_ 位數: Int) -> String {
        guard 位數 > 0 else { return String(self) }
        
        let formatTxt = "%.\(位數)f"
        return .init(format: formatTxt, self)
    }
}

class 模擬抽噴火龍EX {
    let 遊戲: 寶可夢TCG = .init(所有玩家: [噴火龍EX玩家()])
    
    func 關鍵牌測試(_ 數量: Int) -> Bool {
        遊戲.所有玩家[0].重置()
        遊戲.所有玩家[0].抽牌堆丟牌(數量: 20 - 數量) {$0 != .噴火龍EX}
        遊戲.所有玩家[0].抽卡(數量: 4)
        
        return 遊戲.所有玩家[0].手牌.first(where: {$0 == .噴火龍EX}) != nil
    }
    
    func loopTest(_ times: Int, 數量: Int) -> Double {
        let count = (0..<times).reduce(0, {
            sum, index in
            return sum + (self.關鍵牌測試(數量) ? 1 : 0)
        })
        return Double(count) / Double(times)
    }
}

class 寶可夢TCG {
    static let 牌組數量上限 = 20
    static let 同卡上限 = 2
    
    let 所有玩家: [寶可夢TCG玩家]
    init(所有玩家: [寶可夢TCG玩家]) {
        self.所有玩家 = 所有玩家
        
        玩家行動 { 玩家 in
            玩家.遊戲 = self
        }
    }
    
    func 重新開始() {
        重置()
        所有玩家[0].新回合()
    }
    
    func 重置() {
        玩家行動 { 玩家 in
            玩家.重置()
            玩家.準備()
        }
    }
    
    func 玩家回合結束(_ 玩家: 寶可夢TCG玩家介面) {
        let 新回合玩家 = 玩家.先手玩家 ? 1 : 0
        所有玩家[新回合玩家].新回合()
    }
    
    func 玩家行動(callback: (寶可夢TCG玩家)->Void) {
        self.所有玩家.forEach {callback($0)}
    }
}

enum 寶可夢TCG卡類型: CaseIterable, Hashable, Equatable {
    case 基礎
    case 一階, 二階
    case 物品
    case 支援者
}
enum 寶可夢屬性: CaseIterable, Hashable, Equatable {
    case 草, 火, 水, 雷, 超, 鬥, 惡, 鋼, 龍, 無
}
struct 寶可夢TCG卡: Hashable, Equatable {
    static let 博士與精靈球: [寶可夢TCG卡] = .init(同卡: .大木博士) + .init(同卡: .精靈球)
    
    static let 雜牌基礎寶可夢: 寶可夢TCG卡 = .init(
        名稱: "雜牌基礎寶可夢",
        類型: .基礎,
        屬性: nil
    )
    static let 雜牌1階寶可夢: 寶可夢TCG卡 = .init(
        名稱: "雜牌基礎寶可夢",
        類型: .一階,
        屬性: nil
    )
    static let 超基礎寶可夢: 寶可夢TCG卡 = .init(
        名稱: "超基礎寶可夢",
        類型: .基礎,
        屬性: .超
    )
    static let 超1階寶可夢: 寶可夢TCG卡 = .init(
        名稱: "超1階寶可夢",
        類型: .一階,
        屬性: .超
    )
    static let 沙奈朵: 寶可夢TCG卡 = .init(
        名稱: "沙奈朵",
        類型: .二階,
        屬性: .超
    )
    static let 超夢EX: 寶可夢TCG卡 = .init(
        名稱: "超夢EX",
        類型: .基礎,
        屬性: .超
    )
    static let 皮卡丘EX: 寶可夢TCG卡 = .init(
        名稱: "皮卡丘EX",
        類型: .基礎,
        屬性: .雷
    )
    static let 噴火龍EX: 寶可夢TCG卡 = .init(
        名稱: "噴火龍EX",
        類型: .二階,
        屬性: .火
    )
    static let 雜牌: 寶可夢TCG卡 = .init(
        名稱: "雜牌",
        類型: .物品,
        屬性: nil
    )
    static let 精靈球: 寶可夢TCG卡 = .init(
        名稱: "精靈球",
        類型: .物品,
        屬性: nil
    )
    static let 幻之石板: 寶可夢TCG卡 = .init(
        名稱: "幻之石板",
        類型: .物品,
        屬性: nil
    )
    static let 大木博士: 寶可夢TCG卡 = .init(
        名稱: "大木博士",
        類型: .支援者,
        屬性: nil
    )
    
    let 名稱: String
    let 類型: 寶可夢TCG卡類型
    let 屬性: 寶可夢屬性?
    
    func 是支援者() -> Bool {
        self.類型 == .支援者
    }
    func 是基礎寶可夢() -> Bool {
        self.類型 == .基礎
    }
}
extension Array where Element == 寶可夢TCG卡 {
    init(卡: 寶可夢TCG卡, 數量: Int) {
        self = Array(repeating: 卡, count: 數量)
    }
    
    init(同卡: 寶可夢TCG卡) {
        self = .init(卡: 同卡, 數量: 寶可夢TCG.同卡上限)
    }
    
    init(雜牌數: Int, 雜牌基礎寶可夢數: Int) {
        self = .init(卡: .雜牌, 數量: 雜牌數) + .init(卡: .雜牌基礎寶可夢, 數量: 雜牌基礎寶可夢數)
    }
    
    mutating func 補雜牌() {
        let 雜牌數 = 寶可夢TCG.牌組數量上限 - count
        guard 雜牌數 > 0 else { return }
        
        append(contentsOf: Array<寶可夢TCG卡>(卡: .雜牌, 數量: 雜牌數))
    }
    
    mutating func 抽(_ 條件: (寶可夢TCG卡)->Bool) -> 寶可夢TCG卡? {
        guard let index = self.firstIndex(where: 條件) else { return nil }
        defer { self.remove(at: index) }
        return self[index]
    }
    
    mutating func 抽(數量: Int) -> [寶可夢TCG卡] {
        let 被抽走的牌 = self.prefix(數量)
        let 被抽走數量 = 被抽走的牌.count
        self = self.suffix(count - 被抽走數量)
        return Array(被抽走的牌)
    }
}

protocol 寶可夢TCG玩家介面 {
    var 遊戲: 寶可夢TCG? {get set}
    var 先手玩家: Bool {get}
    func 用精靈球如果有()
    func 用大木博士如果有()
    
    func 建立牌組() -> [寶可夢TCG卡]
    func 新回合()
    func 新回合抽卡()
}

extension 寶可夢TCG玩家介面 {
    func 建立牌組() -> [寶可夢TCG卡] {
        var cards = 寶可夢TCG卡.博士與精靈球
        cards.補雜牌()
        return cards
    }
    
    func 新回合() {
        新回合抽卡()
        用精靈球跟大木博士()
        
        self.遊戲?.玩家回合結束(self)
    }
    
    func 用精靈球跟大木博士() {
        用精靈球如果有()
        用精靈球如果有()
        
        用大木博士如果有()
    }
}

class 陪練玩家: 寶可夢TCG玩家 {
    func 新回合() {
        self.遊戲?.玩家回合結束(self)
    }
}

class 噴火龍EX玩家: 寶可夢TCG玩家 {
    func 建立牌組() -> [寶可夢TCG卡] {
        var cards: [寶可夢TCG卡] = .init(同卡: .噴火龍EX) //+ 寶可夢TCG卡.博士與精靈球
        + .init(同卡: .雜牌基礎寶可夢)//火焰鳥
        + .init(同卡: .雜牌基礎寶可夢)//小火龍
        + .init(同卡: .雜牌1階寶可夢)//火恐龍
        cards.補雜牌()
        return cards
    }
}

class 寶可夢TCG玩家: 寶可夢TCG玩家介面 {
    weak var 遊戲: 寶可夢TCG?
    var 先手玩家: Bool = true
    
    private lazy var 牌組: [寶可夢TCG卡] = 建立牌組()
    
    private(set) var 手牌: [寶可夢TCG卡] = []
    private(set) var 抽牌堆: [寶可夢TCG卡] = []
    private(set) var 棄牌堆: [寶可夢TCG卡] = []
    
    func 重置() {
        抽牌堆 = 牌組
        
        手牌 = []
        棄牌堆 = []
        
        洗牌()
    }
    
    func 抽牌堆丟牌(數量: Int, 條件: (寶可夢TCG卡)->Bool) {
        var 數量 = 數量
        while 數量 > 0, let 雜牌 = 抽牌堆.抽(條件) {
            棄牌堆 += [雜牌]
            數量 -= 1
        }
    }
    
    func 抽牌堆丟雜牌(數量: Int) {
        var 數量 = 數量
        while 數量 > 0, let 雜牌 = 抽牌堆.抽({$0 == .雜牌}) {
            棄牌堆 += [雜牌]
            數量 -= 1
        }
    }
    
    func 洗牌() {
        抽牌堆.shuffle()
    }
    
    func 準備() {
        guard let 基礎寶可夢 = 抽牌堆.抽({
            $0.是基礎寶可夢()
        }) else { fatalError("抽牌堆, 無基礎寶可夢") }
        
        抽卡(數量: 4)
    }
    
    func 新回合抽卡() {
        抽卡(數量: 1)
    }
    
    func 抽卡(數量: Int) {
        手牌 += 抽牌堆.抽(數量: 數量)
    }
    
    func 用精靈球如果有() {
        guard 丟手牌(.精靈球) else { return }
        
        guard let 基礎寶可夢 = 抽牌堆.抽({
            $0.是基礎寶可夢()
        }) else {return}
        
        手牌 += [基礎寶可夢]
        洗牌()
    }
    
    func 用大木博士如果有() {
        guard 丟手牌(.大木博士) else { return }
        
        抽卡(數量: 2)
    }
    
    private func 丟手牌(_ 卡: 寶可夢TCG卡) -> Bool {
        guard let 手牌的卡 = 手牌.抽({$0 == 卡}) else { return false }
        
        棄牌堆 += [手牌的卡]
        return true
    }
}