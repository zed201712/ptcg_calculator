//
//  PtcgDeck.swift
//  ptcg_calculator
//
//  Created by Yuu on 2025/1/13.
//

import Foundation

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
    
    func 補牌(_ 卡: 寶可夢牌, 加入 數量: Int, 數量上限: Int) -> [寶可夢牌] {
        var cards: [寶可夢牌] = self
        
        let maxCount = 數量上限 - cards.count
        let 數量 = Swift.min(maxCount, 數量)
        cards += .init(牌: 卡, 數量: 數量)
        return cards
    }
    
    func 補雜牌(_ 雜牌基礎寶可夢數量: Int, 數量上限: Int) -> [寶可夢牌] {
        補牌(.雜牌基礎寶可夢, 加入: 雜牌基礎寶可夢數量, 數量上限: 數量上限).補雜牌(數量上限)
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
