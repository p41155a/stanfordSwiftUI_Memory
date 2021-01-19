//
//  MemoryGame.swift
//  Memorize
//
//  Created by Yoojin Park on 2021/01/05.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    // Equatable : cards[chosenIndex].content == cards[potentialMatchIndex].content 에서 비교해주기 위함(image와 같은 것들은 비교 불가 할 수도 있음)
    var cards: Array<Card>
    
    // 하나의 카드만 뒤집혔을 때 그 카드의 index
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
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
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent // 숫자, 문자, 이미지 어떤것이든 들어가기 위해 위에서 generic인것을 볼 수 있음
        var id: Int
    }
}

