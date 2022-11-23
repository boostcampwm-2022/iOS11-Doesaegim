//
//  PickerViewProtocol.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/22.
//

import Foundation

protocol PickerViewProtocol: AnyObject {
    var delegate: PickerViewDelegate? { get set }
}

protocol PickerViewDelegate: AnyObject {
    func selectedExchangeInfo(item: ExchangeResponse)
    func selectedCategory(item: String)
}
