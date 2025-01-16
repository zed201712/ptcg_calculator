//
//  PtcgPlayer.swift
//  ptcg_calculator
//
//  Created by Yuu on 2025/1/13.
//

import Foundation

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

class 紅卡玩家: 寶可夢玩家 {
    override var 名稱: String { "紅卡" }
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
    override var 名稱: String { "陪練" }
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
    override var 名稱: String { "皮卡丘EX" }
    override func 取得核心牌組() -> [寶可夢牌] {
        .init(同卡: .皮卡丘EX)
        + .博士與精靈球
    }
}

class 沙奈朵玩家: 寶可夢玩家 {
    override var 名稱: String { "沙奈朵" }
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

class 噴火龍玩家: 寶可夢玩家 {
    override var 名稱: String { "噴火龍" }
    override func 取得核心牌組() -> [寶可夢牌] {
        .init(同卡: .小火龍)
        + .init(同卡: .火恐龍)
        + .init(同卡: .噴火龍EX)
        + .博士與精靈球
    }
    
    override func 出牌階段() {
        super.出牌階段()
        出關鍵牌如果能()
    }
    
    private func 出關鍵牌如果能() {
        //debug_msg(self, 1, "\(#function)")
        
        let 上回合幾張小火龍 = 棄牌堆.有幾張({$0 == .小火龍})
        let 上回合幾張火恐龍 = 棄牌堆.有幾張({$0 == .火恐龍})
        let 上回合幾張噴火龍EX = 棄牌堆.有幾張({$0 == .噴火龍EX})
        
        for _ in 0 ..< 遊戲!.同卡上限 {
            _ = 棄牌(.小火龍)
        }
        guard 遊戲!.目前為可進化回合() else { return }
        
        let 小火龍火恐龍張數差 = 上回合幾張小火龍 - 上回合幾張火恐龍
        for _ in 0 ..< 小火龍火恐龍張數差 {
            _ = 棄牌(.火恐龍)
        }
        let 火恐龍噴火龍張數差 = 上回合幾張火恐龍 - 上回合幾張噴火龍EX
        for _ in 0 ..< 火恐龍噴火龍張數差 {
            _ = 棄牌(.噴火龍EX)
        }
    }
}

class 寶可夢玩家 {
    weak var 遊戲: 寶可夢TCG?
    var 名稱: String { "寶可夢玩家" }
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
    
    required init() {}
    
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
    
    func 測試用手牌放回抽牌堆(_ 手牌最後幾張: Int) {
        let 手牌數 = 手牌.count
        assert(手牌最後幾張 <= 手牌數)
        let 被拿走的牌 = 手牌.suffix(手牌最後幾張)
        手牌 = Array(手牌.prefix(手牌數 - 手牌最後幾張))
        
        抽牌堆 = 被拿走的牌 + 抽牌堆
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
        
        if let 基礎寶可夢 = 抽牌堆.抽({ $0.是基礎寶可夢() }) {
            手牌 += [基礎寶可夢]
        }
        洗牌()
        
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
