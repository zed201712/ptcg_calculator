//
//  RedCardProbability.swift
//  ptcg_calculator
//
//  Created by Yuu on 2025/1/1.
//

import Foundation

extension Double {
    func toDotString(_ digits: Int) -> String {
        guard digits > 0 else { return String(self) }
        
        let formatTxt = "%.\(digits)f"
        return .init(format: formatTxt, self)
    }
}

class HasKeyCard {
    static func testing() {
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
    }
    
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
    
    func drawKeyCardAllHit(_ total: Int, keyCardCount: Int, drawCardCount: Int) -> Double {
        let totalCombinations = combination(total, drawCardCount)
        
        let nonJokerCombinations = combination(total - keyCardCount, drawCardCount - keyCardCount)
        
        let favorableCombinations = nonJokerCombinations
        
        return Double(favorableCombinations) / Double(totalCombinations)
    }
    
    func drawKeyCardAndRequiredCard(_ total: Int, keyCardCount: Int, other requiredCardCount: Int, drawCardCount: Int) -> Double {
        let otherDrawn = 1
        
        let otherCards = total - keyCardCount - requiredCardCount
        let totalCombinations = combination(total, drawCardCount)
        let jokerCombinations = 1
        
        let lessThanCombinations = combination(requiredCardCount, 1)
        
        let otherCombinations = combination(otherCards, otherDrawn)
        
        // 計算機率
        return Double(jokerCombinations * lessThanCombinations * otherCombinations) / Double(totalCombinations)
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
