//
//  PtcgTester.swift
//  ptcg_calculator
//
//  Created by Yuu on 2025/1/3.
//

import Foundation

protocol 寶可夢測試者 {
    var 玩家: 寶可夢玩家 {get}
    func 測試()
}
extension 寶可夢測試者 {
    static func 執行所有測試() {
        let 所有測試者: [寶可夢測試者] = [
            幻之石板測試者(),
            大木博士精靈球測試者(),
            重新遊戲測試者(),
            精靈球測試者(),
            大木博士測試者(),
        ]
        
        for 測試者 in 所有測試者 {
            debug_msg(測試者.玩家, 0, "_______________")
            debug_msg(測試者.玩家, 0, "\(測試者)")
            測試者.測試()
        }
    }
}
class 實體測試者: 寶可夢測試者 {
    let 玩家 = 寶可夢玩家()
    func 測試() {}
}

struct 寶可夢測試者牌組資料 {
    let 手牌: [寶可夢牌]?
    let 抽牌堆: [寶可夢牌]?
    let 棄牌堆: [寶可夢牌]?
    
    func 設定玩家牌堆(_ 玩家: 寶可夢玩家) {
        let 初始化手牌 = 手牌 ?? []
        let 初始化抽牌堆 = 抽牌堆 ?? []
        let 初始化棄牌堆 = 棄牌堆 ?? []
        
        let 初始化牌組 = 初始化棄牌堆 + 初始化手牌 + 初始化抽牌堆
        
        玩家.測試用重置抽牌堆(初始化牌組)
        玩家.抽牌(數量: 初始化棄牌堆.count + 初始化手牌.count)
        玩家.棄牌(數量: 初始化棄牌堆.count)
    }
    
    func 比對結果(_ 玩家: 寶可夢玩家) {
        if let 預測手牌 = 手牌 {
            assert(預測手牌 == 玩家.手牌, "\(玩家.牌堆數量資訊())")
        }
        if let 預測抽牌堆 = 抽牌堆 {
            assert(預測抽牌堆 == 玩家.抽牌堆, "\(玩家.牌堆數量資訊())")
        }
        if let 預測棄牌堆 = 棄牌堆 {
            assert(預測棄牌堆 == 玩家.棄牌堆, "\(玩家.牌堆數量資訊())")
        }
    }
}

class 寶可夢基礎測試者 {
    let 玩家 = 測試者用寶可夢玩家()
    private let 陪練: 寶可夢玩家 = {
        let player = 陪練玩家.後手陪練玩家()
        player.重置牌組([.雜牌基礎寶可夢])
        return player
    }()
    private(set) lazy var 遊戲 = 測試者用寶可夢TCG(所有玩家: [玩家, 陪練])
    
    func 重置數據() {
        玩家.重置數據()
        遊戲.重置數據()
    }
    
    func 測試(_ 牌組: 寶可夢測試者牌組資料, 牌組數量上限: Int, 測試過程: ()->Void) {
        遊戲.牌組數量上限 = 牌組數量上限
        遊戲.重置()
        
        牌組.設定玩家牌堆(玩家)
        
        重置數據()
        測試過程()
    }
    
    func 檢查遊戲(
        重新開始次數: Int? = nil,
        重置次數: Int? = nil,
        準備次數: Int? = nil,
        開始次數: Int? = nil
    ) {
        if let 重新開始次數 { assert(self.遊戲.資料.重新開始次數 == 重新開始次數) }
        if let 重置次數 { assert(self.遊戲.資料.重置次數 == 重置次數) }
        if let 準備次數 { assert(self.遊戲.資料.準備次數 == 準備次數) }
        if let 開始次數 { assert(self.遊戲.資料.開始次數 == 開始次數) }
    }
    
    func 檢查玩家(
        新回合次數: Int? = nil,
        重置牌組次數: Int? = nil,
        重置次數: Int? = nil,
        洗牌次數: Int? = nil,
        準備次數: Int? = nil,
        抽牌次數: Int? = nil,
        出牌次數: Int? = nil,
        棄牌次數: Int? = nil,
        
        手牌數量: Int? = nil,
        抽牌堆數量: Int? = nil,
        棄牌堆數量: Int? = nil
    ) {
        if let 重置牌組次數 { assert(self.玩家.資料.重置牌組次數 == 重置牌組次數) }
        if let 重置次數 { assert(self.玩家.資料.重置次數 == 重置次數) }
        if let 洗牌次數 { assert(self.玩家.資料.洗牌次數 == 洗牌次數) }
        if let 準備次數 { assert(self.玩家.資料.準備次數 == 準備次數) }
        if let 抽牌次數 { assert(self.玩家.資料.抽牌次數 == 抽牌次數) }
        if let 新回合次數 { assert(self.玩家.資料.新回合次數 == 新回合次數) }
        if let 出牌次數 { assert(self.玩家.資料.出牌次數 == 出牌次數) }
        if let 棄牌次數 { assert(self.玩家.資料.棄牌次數 == 棄牌次數) }
        
        if let 手牌數量 { assert(self.玩家.手牌.count == 手牌數量) }
        if let 抽牌堆數量 { assert(self.玩家.抽牌堆.count == 抽牌堆數量) }
        if let 棄牌堆數量 { assert(self.玩家.棄牌堆.count == 棄牌堆數量) }
    }
}

class 測試者用寶可夢TCG: 寶可夢TCG {
    struct 測試資料 {
        var 重新開始次數: Int = 0
        var 重置次數: Int = 0
        var 準備次數: Int = 0
        var 開始次數: Int = 0
    }
    var 資料 = 測試資料()
    
    func 重置數據() {
        資料 = 測試資料()
    }
    
    override func 重新開始() {
        資料.重新開始次數 += 1
        super.重新開始()
    }
    override func 重置() {
        資料.重置次數 += 1
        super.重置()
    }
    override func 準備() {
        資料.準備次數 += 1
        super.準備()
    }
    override func 開始() {
        資料.開始次數 += 1
        super.開始()
    }
    
}

class 測試者用寶可夢玩家: 寶可夢玩家 {
    struct 測試資料 {
        var 重置牌組次數: Int = 0
        var 重置次數: Int = 0
        var 洗牌次數: Int = 0
        var 準備次數: Int = 0
        var 抽牌次數: Int = 0
        var 新回合次數: Int = 0
        var 出牌次數: Int = 0
        var 棄牌次數: Int = 0
    }
    var 資料 = 測試資料()
    
    func 重置數據() {
        資料 = 測試資料()
    }
    
    override func 取得核心牌組() -> [寶可夢牌] {
        .init(雜牌數: 0, 雜牌基礎寶可夢數: 1)
    }
    
    override func 重置牌組(_ 牌組: [寶可夢牌]) {
        資料.重置牌組次數 += 1
        super.重置牌組(牌組)
    }
    override func 重置() {
        資料.重置次數 += 1
        super.重置()
    }
    override func 洗牌() {
        資料.洗牌次數 += 1
        super.洗牌()
    }
    override func 準備() {
        資料.準備次數 += 1
        super.準備()
    }
    override func 抽牌(數量: Int) {
        資料.抽牌次數 += 1
        super.抽牌(數量: 數量)
    }
    override func 新回合() {
        資料.新回合次數 += 1
        super.新回合()
    }
    override func 執行出牌策略(_ 策略: 寶可夢出牌策略) -> Bool {
        let result = super.執行出牌策略(策略)
        if result { 資料.出牌次數 += 1 }
        return result
    }
    override func 棄牌(_ 牌: 寶可夢牌) -> Bool {
        let result = super.棄牌(牌)
        if result { 資料.棄牌次數 += 1 }
        return result
    }
}

class 幻之石板測試者: 寶可夢測試者, 寶可夢TCG控制器 {
    private let 測試者 = 寶可夢基礎測試者()
    private var 目前回合: Int {遊戲.目前回合}
    var 玩家: 寶可夢玩家 {測試者.玩家}
    private var 遊戲: 寶可夢TCG {測試者.遊戲}
    
    private var 目前測試編號: Int = 0
    private let 預測結束結果: [[寶可夢測試者牌組資料]] = [
        //測試編號 = 0
        [
            //初始設定
            .init(
                手牌: [],
                抽牌堆: [.幻之石板, .拉魯拉絲, .幻之石板, .奇魯莉安, .大木博士, ],
                棄牌堆: []
            ),
            
            //回合 = 1
            .init(
                手牌: [.拉魯拉絲, ],
                抽牌堆: [.幻之石板, .奇魯莉安, .大木博士, ],
                棄牌堆: [.幻之石板, ]
            ),
            //回合 = 2
            .init(
                手牌: [.拉魯拉絲, .奇魯莉安, ],
                抽牌堆: [.大木博士, ],
                棄牌堆: [.幻之石板, .幻之石板, ]
            ),
            //回合 = 3
            .init(
                手牌: [.拉魯拉絲, .奇魯莉安, .大木博士, ],
                抽牌堆: [],
                棄牌堆: [.幻之石板, .幻之石板, ]
            ),
        ],
        
        //測試編號 = 1
        [
            //初始設定
            .init(
                手牌: [.幻之石板, .幻之石板, ],
                抽牌堆: [.幻之石板, .雜牌, .大木博士, .沙奈朵, ],
                棄牌堆: []
            ),
            
            //回合 = 1
            .init(
                手牌: [.沙奈朵, ],
                抽牌堆: [.雜牌, .大木博士, ],
                棄牌堆: [.幻之石板, .幻之石板, .幻之石板, ]
            ),
            //回合 = 2
            .init(
                手牌: [.沙奈朵, .雜牌, ],
                抽牌堆: [.大木博士, ],
                棄牌堆: [.幻之石板, .幻之石板, .幻之石板, ]
            ),
            //回合 = 3
            .init(
                手牌: [.沙奈朵, .雜牌, .大木博士, ],
                抽牌堆: [],
                棄牌堆: [.幻之石板, .幻之石板, .幻之石板, ]
            ),
        ],
    ]
    
    func 測試() {
        遊戲.控制器 = self
        玩家.出牌策略 = [
            .init(牌: .幻之石板, 只出一張: false)
        ]
        
        for 測試編號 in 0 ..< 預測結束結果.count {
            目前測試編號 = 測試編號
            測試者.測試(
                預測結束結果[測試編號][0],
                牌組數量上限: 20
            ) {
                self.遊戲.開始()
            }
        }
    }
    
    func 回合結束(_ 玩家: 寶可夢玩家) {
        guard self.玩家 === 玩家 else { return }
        let 牌堆數量 = self.玩家.牌堆數量資訊([\.抽牌堆])
        let 牌堆 = self.玩家.牌堆資訊([\.手牌, \.棄牌堆])
        debug_msg(self.玩家, 0, "測試者[\(目前測試編號)], 回合[\(目前回合)], \(牌堆數量), \(牌堆)")
        預測結束結果[目前測試編號][目前回合].比對結果(self.玩家)
    }
    
    func 是否遊戲結束() -> Bool {
        測試者.遊戲.目前回合 >= 預測結束結果[目前測試編號].count - 1
    }
    
    func 遊戲結束() {}
}

class 大木博士精靈球測試者: 寶可夢測試者, 寶可夢TCG控制器 {
    private let 測試者 = 寶可夢基礎測試者()
    private var 目前回合: Int {遊戲.目前回合}
    var 玩家: 寶可夢玩家 {測試者.玩家}
    private var 遊戲: 寶可夢TCG {測試者.遊戲}
    
    private var 目前測試編號: Int = 0
    private let 預測結束結果: [[寶可夢測試者牌組資料]] = [
        //測試編號 = 0
        [
            //初始設定
            .init(
                手牌: [.精靈球, .精靈球, .大木博士,],
                抽牌堆: [.精靈球, .大木博士],
                棄牌堆: []
            ),
            
            //回合 = 1
            .init(
                手牌: [.大木博士],
                抽牌堆: [],
                棄牌堆: [.大木博士, .精靈球, .精靈球, .精靈球,]
            ),
        ],
        
        //測試編號 = 1
        [
            //初始設定
            .init(
                手牌: [.精靈球, .大木博士, .精靈球,],
                抽牌堆: [.精靈球, .大木博士],
                棄牌堆: []
            ),
            
            //回合 = 1
            .init(
                手牌: [.大木博士],
                抽牌堆: [],
                棄牌堆: [.大木博士, .精靈球, .精靈球, .精靈球,]
            ),
        ],
    ]
    
    func 測試() {
        遊戲.控制器 = self
        玩家.出牌策略 = [
            .init(牌: .大木博士, 只出一張: true),
            .init(牌: .精靈球, 只出一張: false),
        ]
        
        for 測試編號 in 0 ..< 預測結束結果.count {
            目前測試編號 = 測試編號
            測試者.測試(
                預測結束結果[測試編號][0],
                牌組數量上限: 20
            ) {
                self.遊戲.開始()
            }
        }
    }
    
    func 回合結束(_ 玩家: 寶可夢玩家) {
        guard self.玩家 === 玩家 else { return }
        let 牌堆數量 = self.玩家.牌堆數量資訊([\.抽牌堆])
        let 牌堆 = self.玩家.牌堆資訊([\.手牌, \.棄牌堆])
        debug_msg(self.玩家, 0, "測試者[\(目前測試編號)], 回合[\(目前回合)], \(牌堆數量), \(牌堆)")
        預測結束結果[目前測試編號][目前回合].比對結果(self.玩家)
    }
    
    func 是否遊戲結束() -> Bool {
        測試者.遊戲.目前回合 >= 預測結束結果[目前測試編號].count - 1
    }
    
    func 遊戲結束() {}
}


class 重新遊戲測試者: 寶可夢測試者, 寶可夢TCG控制器 {
    private let 測試者 = 寶可夢基礎測試者()
    private var 目前回合: Int {遊戲.目前回合}
    var 玩家: 寶可夢玩家 {測試者.玩家}
    private var 遊戲: 寶可夢TCG {測試者.遊戲}
    
    private let 寶 = 寶可夢牌.雜牌基礎寶可夢
    private let 物 = 寶可夢牌.雜牌
    
    private var 目前測試編號: Int = 0
    
    private let 遊戲開始測試編號 = 0
    private let 遊戲重新開始測試編號 = 1
    private let 遊戲準備測試編號 = 2
    private let 遊戲重置測試編號 = 3
    
    private lazy var 預測結束結果: [[寶可夢測試者牌組資料]] = [
        //測試編號 = 0 => 遊戲開始測試編號
        [
            //初始設定
            .init(
                手牌: [],
                抽牌堆: [寶, 寶, ],
                棄牌堆: []
            ),
            
            //回合 = 1
            .init(
                手牌: [寶, ],
                抽牌堆: [寶, ],
                棄牌堆: []
            ),
            
            //回合 = 2
            .init(
                手牌: [寶, 寶, ],
                抽牌堆: [],
                棄牌堆: []
            ),
        ],
    ]
    
    private func 回合結束特例確認() {
        switch 目前測試編號 {
        case 遊戲重新開始測試編號:
            assert( 目前回合 == 1 )//準備階段無法結束遊戲
            self.測試者.檢查玩家(
                新回合次數: 1,
                重置牌組次數: 0,
                重置次數: 1,
                洗牌次數: 2,//玩家重置 + 玩家準備
                準備次數: 1,
                抽牌次數: 2,
                出牌次數: 0,
                棄牌次數: 0,
                
                手牌數量: 2,
                抽牌堆數量: 0,
                棄牌堆數量: 0
            )
        case 遊戲準備測試編號:
            assert( 目前回合 == 0 )
            self.測試者.檢查玩家(
                新回合次數: 0,
                重置牌組次數: 0,
                重置次數: 0,
                洗牌次數: 1,
                準備次數: 1,
                抽牌次數: 1,
                出牌次數: 0,
                棄牌次數: 0,
                
                手牌數量: 2,
                抽牌堆數量: 0,
                棄牌堆數量: 0
            )
        case 遊戲重置測試編號:
            assert( 目前回合 == 0 )
            self.測試者.檢查玩家(
                新回合次數: 0,
                重置牌組次數: 0,
                重置次數: 1,
                洗牌次數: 1,
                準備次數: 0,
                抽牌次數: 0,
                出牌次數: 0,
                棄牌次數: 0,
                
                手牌數量: 0,
                抽牌堆數量: 2,
                棄牌堆數量: 0
            )
        default:
            break
        }
    }
    
    func 測試() {
        遊戲.控制器 = self
        玩家.出牌策略 = []
        
        目前測試編號 = 遊戲開始測試編號
        測試者.測試(
            預測結束結果[0][0],
            牌組數量上限: 2
        ) {
            self.遊戲.開始()
        }
        
        目前測試編號 = 遊戲重新開始測試編號
        測試者.測試(
            預測結束結果[0][0],
            牌組數量上限: 2
        ) {
            self.遊戲.重新開始()
        }
        
        目前測試編號 = 遊戲準備測試編號
        測試者.測試(
            預測結束結果[0][0],
            牌組數量上限: 2
        ) {
            self.遊戲.準備()
        }
        回合結束特例確認()
        
        目前測試編號 = 遊戲重置測試編號
        測試者.測試(
            預測結束結果[0][0],
            牌組數量上限: 2
        ) {
            self.遊戲.重置()
        }
        回合結束特例確認()
    }
    
    func 回合結束(_ 玩家: 寶可夢玩家) {
        guard 目前測試編號 == 遊戲開始測試編號 else {
            回合結束特例確認()
            return
        }
        guard self.玩家 === 玩家 else { return }
        
        let 牌堆數量 = self.玩家.牌堆數量資訊([\.抽牌堆])
        let 牌堆 = self.玩家.牌堆資訊([\.手牌, \.棄牌堆])
        debug_msg(self.玩家, 0, "遊戲編號[\(遊戲開始測試編號)], 回合[\(目前回合)], \(牌堆數量), \(牌堆)")
        預測結束結果[遊戲開始測試編號][目前回合].比對結果(self.玩家)
        回合結束特例確認()
    }
    
    func 是否遊戲結束() -> Bool {
        玩家.抽牌堆.isEmpty
    }
    
    func 遊戲結束() {}
}

class 精靈球測試者: 寶可夢測試者, 寶可夢TCG控制器 {
    private let 測試者 = 寶可夢基礎測試者()
    private var 目前回合: Int {遊戲.目前回合}
    var 玩家: 寶可夢玩家 {測試者.玩家}
    private var 遊戲: 寶可夢TCG {測試者.遊戲}
    
    private let 寶 = 寶可夢牌.雜牌基礎寶可夢
    private let 物 = 寶可夢牌.雜牌
    private let 球 = 寶可夢牌.精靈球
    
    private var 目前測試編號: Int = 0
    private lazy var 預測結束結果: [[寶可夢測試者牌組資料]] = [
        //測試編號 = 0
        [
            //初始設定
            .init(
                手牌: [球 ],
                抽牌堆: [寶, 寶, ],
                棄牌堆: []
            ),
            
            //回合 = 1
            .init(
                手牌: [寶, 寶, ],
                抽牌堆: [],
                棄牌堆: [球]
            ),
        ],
        
        //測試編號 = 1
        [
            //初始設定
            .init(
                手牌: [],
                抽牌堆: [寶, 球, 物, 寶, ],
                棄牌堆: []
            ),
            
            //回合 = 1
            .init(
                手牌: [寶, ],
                抽牌堆: [球, 物, 寶,],
                棄牌堆: []
            ),
            //回合 = 2
            .init(
                手牌: [寶, 寶, ],
                抽牌堆: [物, ],
                棄牌堆: [球, ]
            ),
            //回合 = 3
            .init(
                手牌: [寶, 寶, 物, ],
                抽牌堆: [],
                棄牌堆: [球, ]
            ),
        ],
        
        //測試編號 = 2
        [
            //初始設定
            .init(
                手牌: [],
                抽牌堆: [球, 物, 寶, 寶, ],
                棄牌堆: []
            ),
            
            //回合 = 1
            .init(
                手牌: [寶, ],
                抽牌堆: nil,//[物, 寶, ]
                棄牌堆: [球, ]
            ),
            //回合 = 2
            .init(
                手牌: nil,//[寶, 物, ]
                抽牌堆: nil,//[寶,]
                棄牌堆: [球, ]
            ),
            //回合 = 3
            .init(
                手牌: nil,//[寶, 物, 寶, ]
                抽牌堆: [],
                棄牌堆: [球, ]
            ),
        ],
    ]
    
    private func 回合結束特例確認() {
        switch 目前測試編號 {
        case 1:
            switch 目前回合 {
            case 1:
                self.測試者.檢查玩家(
                    新回合次數: 1,
                    洗牌次數: 0,
                    出牌次數: 0
                )
            case 2:
                self.測試者.檢查玩家(
                    新回合次數: 2,
                    洗牌次數: 1,
                    出牌次數: 1
                )
            case 3:
                self.測試者.檢查玩家(
                    新回合次數: 3,
                    洗牌次數: 1,
                    出牌次數: 1
                )
            default:
                break
            }
        case 2:
            switch 目前回合 {
            case 1:
                self.測試者.檢查玩家(
                    新回合次數: 1,
                    洗牌次數: 1,
                    出牌次數: 1,
                    
                    手牌數量: 1,
                    抽牌堆數量: 2
                )
            case 2:
                self.測試者.檢查玩家(
                    新回合次數: 2,
                    洗牌次數: 1,
                    出牌次數: 1,
                    
                    手牌數量: 2,
                    抽牌堆數量: 1
                )
            case 3:
                self.測試者.檢查玩家(
                    新回合次數: 3,
                    洗牌次數: 1,
                    出牌次數: 1,
                    
                    手牌數量: 3,
                    抽牌堆數量: 0
                )
            default:
                break
            }
        default:
            break
        }
    }
    
    func 測試() {
        遊戲.控制器 = self
        玩家.出牌策略 = [
            .init(牌: .精靈球, 只出一張: false)
        ]
        
        for 測試編號 in 0 ..< 預測結束結果.count {
            目前測試編號 = 測試編號
            測試者.測試(
                預測結束結果[測試編號][0],
                牌組數量上限: 20
            ) {
                self.遊戲.開始()
            }
        }
    }
    
    func 回合結束(_ 玩家: 寶可夢玩家) {
        guard self.玩家 === 玩家 else { return }
        
        let 牌堆數量 = self.玩家.牌堆數量資訊([\.抽牌堆])
        let 牌堆 = self.玩家.牌堆資訊([\.手牌, \.棄牌堆])
        debug_msg(self.玩家, 0, "遊戲編號[\(目前測試編號)], 回合[\(目前回合)], \(牌堆數量), \(牌堆)")
        預測結束結果[目前測試編號][目前回合].比對結果(self.玩家)
        回合結束特例確認()
    }
    
    func 是否遊戲結束() -> Bool {
        玩家.抽牌堆.isEmpty
    }
    
    func 遊戲結束() {}
}

class 大木博士測試者: 寶可夢測試者, 寶可夢TCG控制器 {
    private let 測試者 = 寶可夢基礎測試者()
    private var 目前回合: Int {遊戲.目前回合}
    var 玩家: 寶可夢玩家 {測試者.玩家}
    private var 遊戲: 寶可夢TCG {測試者.遊戲}
    
    private var 目前測試編號: Int = 0
    private let 預測結束結果: [[寶可夢測試者牌組資料]] = [
        //測試編號 = 0
        [
            //初始設定
            .init(
                手牌: [.大木博士,],
                抽牌堆: .init(牌: .雜牌, 數量: 4) + [.大木博士, .雜牌, .雜牌,],
                棄牌堆: []
            ),
            
            //回合 = 1
            .init(
                手牌: [.雜牌] + [.雜牌, .雜牌],
                抽牌堆: [.雜牌, .大木博士, .雜牌, .雜牌,],
                棄牌堆: [.大木博士]
            ),
            //回合 = 2
            .init(
                手牌: [.雜牌] + [.雜牌, .雜牌] + [.雜牌],
                抽牌堆: [.大木博士, .雜牌, .雜牌,],
                棄牌堆: [.大木博士,]
            ),
            //回合 = 3
            .init(
                手牌: [.雜牌] + [.雜牌, .雜牌] + [.雜牌] + [.雜牌, .雜牌],
                抽牌堆: [],
                棄牌堆: [.大木博士, .大木博士,]
            ),
        ],
        
        //測試編號 = 1
        [
            //初始設定
            .init(
                手牌: [.大木博士, .大木博士,],
                抽牌堆: .init(牌: .雜牌, 數量: 4) + [.大木博士, .雜牌, .雜牌,],
                棄牌堆: []
            ),
            
            //回合 = 1
            .init(
                手牌: [.大木博士] + [.雜牌] + [.雜牌, .雜牌],
                抽牌堆: [.雜牌, .大木博士, .雜牌, .雜牌,],
                棄牌堆: [.大木博士,]
            ),
            //回合 = 2
            .init(
                手牌: [.雜牌] + [.雜牌, .雜牌] + [.雜牌] + [.大木博士, .雜牌],
                抽牌堆: [.雜牌,],
                棄牌堆: [.大木博士, .大木博士,]
            ),
            //回合 = 3
            .init(
                手牌: .init(牌: .雜牌, 數量: 6),
                抽牌堆: [],
                棄牌堆: .init(牌: .大木博士, 數量: 3)
            ),
        ],
    ]
    
    func 測試() {
        遊戲.控制器 = self
        玩家.出牌策略 = [
            .init(牌: .大木博士, 只出一張: true)
        ]
        
        for 測試編號 in 0 ..< 預測結束結果.count {
            目前測試編號 = 測試編號
            測試者.測試(
                預測結束結果[測試編號][0],
                牌組數量上限: 20
            ) {
                self.遊戲.開始()
            }
        }
    }
    
    func 回合結束(_ 玩家: 寶可夢玩家) {
        guard self.玩家 === 玩家 else { return }
        let 牌堆數量 = self.玩家.牌堆數量資訊([\.抽牌堆])
        let 牌堆 = self.玩家.牌堆資訊([\.手牌, \.棄牌堆])
        debug_msg(self.玩家, 0, "測試者[\(目前測試編號)], 回合[\(目前回合)], \(牌堆數量), \(牌堆)")
        預測結束結果[目前測試編號][目前回合].比對結果(self.玩家)
    }
    
    func 是否遊戲結束() -> Bool {
        測試者.遊戲.目前回合 >= 預測結束結果[目前測試編號].count - 1
    }
    
    func 遊戲結束() {}
}
