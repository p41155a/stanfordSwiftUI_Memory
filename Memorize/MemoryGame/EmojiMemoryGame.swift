//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Yoojin Park on 2021/01/05.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject { // ObservableObject는 class에서만 작동
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    // createMemoryGame가 static이 아니라면 -> 속성 이니셜 라이저 내에서 인스턴스 멤버 'createMemoryGame'을 사용할 수 없습니다. 속성 이니셜 라이저는 'self'를 사용할 수 있기 전에 실행됩니다.
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃", "💀"]
        return MemoryGame<String>(numberOfPairOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // MARK: - Acces to the Model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
