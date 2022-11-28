//
//  CustomCalendarCellProtocol.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/28.
//

import Foundation

protocol CustomCalendarCellProtocol: AnyObject {
    var delegate: CustomCalendarCellDelegate? { get set }
    var isSunday: Bool { get set }
    
    func checkDateIsSunday(to date: Date)
}

protocol CustomCalendarCellDelegate: AnyObject {
    func changeLabelColor(isSunday: Bool)
}
