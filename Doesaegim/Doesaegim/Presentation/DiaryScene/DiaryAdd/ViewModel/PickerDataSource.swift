//
//  PickerDataSource.swift
//  Doesaegim
//
//  Created by sun on 2022/11/22.
//

import UIKit

/// Picker가 나타낼 데이터  셋인 T의 배열을 갖고 있는 UIPickerViewDataSource
final class PickerDataSource<T>: NSObject, UIPickerViewDataSource {

    // MARK: - Enums

    enum Section: CaseIterable {
        case main
    }


    // MARK: - Properties

    private let items: [T]


    // MARK: - Init

    init(items: [T]) {
        self.items = items
    }


    // MARK: - DataSource Functions

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        Section.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items.count
    }


    // MARK: - Syntatic sugar Functions

    /// 해당 위치에 아이템이 있는 경우 아이템, 없으면 nil 리턴
    func itemForRow(_ row: Int) -> T? {
        items[safeIndex: row]
    }
}
