//
//  TravelAddViewProtocol.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/16.
//

import Foundation

protocol TravelAddViewProtocol: AnyObject {
    var delegate: TravelAddViewDelegate? { get set }
    var isVaildTextField: Bool { get set }
    var isVaildDate: Bool { get set }
}

protocol TravelAddViewDelegate: AnyObject {
    func isVaildView(isVaild: Bool)
}
