//
//  MemoryGame.swift
//  Memorize
//
//  Created by Yoojin Park on 2021/01/05.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    // Equatable : cards[chosenIndex].content == cards[potentialMatchIndex].content 에서 비교해주기 위함(image와 같은 것들은 비교 불가 할 수도 있음)
    private(set) var cards: Array<Card>
    
    // 하나의 카드만 뒤집혔을 때 그 카드의 index
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only } // 뒤집혀있는 것이 하나일 때만 값이 있음으로 표시
        set { // 이번에 들어온 index 빼고 다 뒤집음
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            // 카드가 뒷면이 보이고 match되지 않은 것들만 뒤집어짐
            // if let에서 && 대신 ,을 사용하기 때문에 순차적으로 진행됨
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard { // 하나만 뒤집혀 있을 때
                if cards[chosenIndex].content == cards[potentialMatchIndex].content { // 지금 뒤집은 카드와 이미 뒤집힌 카드가 같을 때
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    init(numberOfPairOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
        cards.shuffle()
    }
    
    // 위에서 card 배열이 이미 private 임으로 구조체를 각 변수가 private 이지 않아도 된다
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
        
        var bonusTimeLimit: TimeInterval = 6
        // 얼마나 오래 카드를 앞면으로 있엇는지
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // 마지막으로 카드를 앞면으로 돌린 시간(앞면 유지)
        var lastFaceUpDate: Date?
        // 카드가 과거에 앞면으로 보여진 누적시간
        var pastFaceUpTime: TimeInterval = 0
        // 보너스 기회가 끝나기 까지 얼마나 남았는지
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // 남은보너스 시간의 퍼센트
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // 보너스 기간동안 카드일치 여부
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // 현재 앞면으로 뒤집혔는지, 일치하지않았는지, 보너스 창을 다 사용하지않았는지
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        // 카드 앞면으로 전환시 불림
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // 카드가 다시 뒤집힐때 불림(혹은 일치할때)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}
