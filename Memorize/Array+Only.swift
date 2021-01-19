//
//  Array+Only.swift
//  Memorize
//
//  Created by Yoojin Park on 2021/01/19.
//

import Foundation

extension Array {
    var only: Element? { // 배열에 하나만 있다면 그 배열의 값을 반환 아니면 nil
        count == 1 ? first : nil
    }
}
