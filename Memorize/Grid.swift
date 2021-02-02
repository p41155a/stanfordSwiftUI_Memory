//
//  Grid.swift
//  Memorize
//
//  Created by Yoojin Park on 2021/01/19.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    // cardView(card:)를 그릴 것이라는 것만 저장 아직 (item)은 모른다
    
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
            // GridLayout형에 이러이러한 화면 크기에 몇개를 넣을 것이다라고 전해줌
            // -> 화면 크기에 맞는 사이드를 알려줄 것
        }
    }
    
    private func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            self.body(for: item, in: layout)
        }
    }

    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item) // 몇번째 item인지
        return viewForItem(item) // 이렇게 함수를 실행할 때 item이 정해지는 것
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index!)) // 이게 없으면 모두 겹쳐짐
    }
}
