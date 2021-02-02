//
//  Array_identifiable.swift
//  Memorize
//
//  Created by Yoojin Park on 2021/01/19.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}
