//
//  SimulationModel.swift
//  ptcg_calculator
//
//  Created by Yuu on 2025/1/13.
//

import Foundation

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

class 模擬抽皮卡丘EX: 模擬測試<皮卡丘EX玩家> {
    override var 目前模型: 模擬測試<皮卡丘EX玩家> {
        模擬抽皮卡丘EX()
    }
    
    override func 是否遊戲結束() -> Bool {
        let 基礎寶可夢充足 = 玩家.手牌.有幾張({$0.是基礎寶可夢()}) >= 4
        let 有皮卡丘 = 玩家.手牌.有({$0 == .皮卡丘EX})
        return 有皮卡丘 && 基礎寶可夢充足
    }
    
    func 數學驗證() {
        for 回合 in 0 ... 20 {
            let result = MathCombination().drawKeyCardAllHit(19, keyCardCount: 3, drawCardCount: 5 - 1 + 回合)
            print("皮卡丘 回合\(回合): " + (result * 100).toDotString(1))
        }
        //簡易模型驗證
        //let simpleModel = 模擬單次抽牌(); simpleModel.loop(300_000, 抽牌數: 5 - 1 + 7, 牌組數量上限: 19, 關鍵牌數: 3) {$0 >= 3}
        
        //無出牌策略
        //皮卡丘 回合0: 0.4
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
    
//    override func 測試前設置(_ 測試次數: Int, _ x: Int, _ 出牌策略: [寶可夢出牌策略]) {
//        super.測試前設置(測試次數, x, 出牌策略)
//    }
}

class 模擬抽寶石海星: 模擬測試<沙奈朵玩家> {
    override var 目前模型: 模擬測試<沙奈朵玩家> {
        模擬抽寶石海星()
    }
    
    override func 是否遊戲結束() -> Bool {
        return 玩家.棄牌堆.有({$0 == .奇魯莉安})
    }
    
    override func 測試前設置(_ 測試次數: Int, _ x: Int, _ 出牌策略: [寶可夢出牌策略]) {
        統計表名稱 = "寶石海星"
        super.測試前設置(測試次數, x, 出牌策略)
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

class 模擬抽沙奈朵: 模擬測試<沙奈朵玩家> {
    override var 目前模型: 模擬測試<沙奈朵玩家> {
        模擬抽沙奈朵()
    }
    
    override func 是否遊戲結束() -> Bool {
        return 玩家.棄牌堆.有({$0 == .沙奈朵})
    }
}

class 模擬測試<模擬玩家: 寶可夢玩家>: 寶可夢TCG控制器 {
    var 遊戲: 寶可夢TCG = .init(所有玩家: [
        模擬玩家(), 陪練玩家.後手陪練玩家()
    ])
    var 玩家: 模擬玩家 {遊戲.所有玩家.first as! 模擬玩家}
    
    var 目前模型: 模擬測試<模擬玩家> {
        模擬測試<模擬玩家>()
    }
    
    lazy var 統計表名稱: String = { 玩家.名稱 }()
    func 計算雜牌基礎寶可夢數量範圍(_ 統計表: 回合統計表) -> ClosedRange<Int> {
        統計表.重置牌組計算範圍(玩家, 最低: 0)
    }
    
    let 統計表 = 回合統計表()
    private var 目前測試數: Int = 0
    private var 已完成 = false
    private var 雜牌基礎寶可夢數量範圍 = 2...6
    private var 所有出牌策略: [[寶可夢出牌策略]] = [
        [
            .init(牌: .幻之石板, 只出一張: false),
            .init(牌: .大木博士, 只出一張: true),
            .init(牌: .精靈球, 只出一張: false),
        ],
        [
            .init(牌: .大木博士, 只出一張: true),
            .init(牌: .精靈球, 只出一張: false),
        ]
    ]
    
    func 回合結束(_ 玩家: 寶可夢玩家) {}
    
    func 是否遊戲結束() -> Bool { true }
    
    func 遊戲結束() {
        統計表.加次數(遊戲.目前回合)
    }
    
    func 測試前設置(_ 測試次數: Int, _ x: Int, _ 出牌策略: [寶可夢出牌策略]) {
        遊戲.控制器 = self
        
        let 統計表名 = "\(統計表名稱), " + 出牌策略.順序名()
        統計表.重置(測試次數, 名稱: 統計表名, 範圍: x ... x, 回合數上限: 遊戲.牌組數量上限)
        統計表.設定(數量: x)
        玩家.重置牌組(雜牌: x)
        
        玩家.出牌策略 = 出牌策略
    }
    
    func 啟動測試() {
        遊戲.重新開始()
    }
    
    private func 測試(_ 測試次數: Int) {
        已完成 = false
        
        for 次數 in 0 ..< 測試次數 {
            目前測試數 = 次數
            啟動測試()
        }
        
        已完成 = true
    }
    
    func 設定雜牌基礎寶可夢數量範圍(_ 範圍: ClosedRange<Int>) {
        雜牌基礎寶可夢數量範圍 = 範圍
    }
    
    func 設定所有出牌策略(_ 所有出牌策略: [[寶可夢出牌策略]]) {
        self.所有出牌策略 = 所有出牌策略
    }
    
    func loop(_ 測試次數: Int) -> [回合統計表] {
        let 所有出牌策略: [[寶可夢出牌策略]] = 所有出牌策略.isEmpty ? [[]] : 所有出牌策略
        
        let 統計表數量 = 雜牌基礎寶可夢數量範圍.count * 所有出牌策略.count
        let 模型: [模擬測試<模擬玩家>] = (0 ..< 統計表數量).map({_ in self.目前模型})
        
        for (出牌策略編號, 出牌策略) in 所有出牌策略.enumerated() {
            for 雜牌基礎寶可夢數量 in 雜牌基礎寶可夢數量範圍 {
                let 模型編號 = (雜牌基礎寶可夢數量 - 雜牌基礎寶可夢數量範圍.lowerBound) + (出牌策略編號 * 雜牌基礎寶可夢數量範圍.count)
                模型[模型編號].測試前設置(測試次數, 雜牌基礎寶可夢數量, 出牌策略)
                
                DispatchQueue.global().async {
                    模型[模型編號].測試(測試次數)
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