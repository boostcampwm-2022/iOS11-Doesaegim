//
//  Array+SafeIndex.swift
//  Doesaegim
//
//  Created by sun on 2022/12/05.
//

import Foundation

extension Array {

    subscript(safeIndex index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
