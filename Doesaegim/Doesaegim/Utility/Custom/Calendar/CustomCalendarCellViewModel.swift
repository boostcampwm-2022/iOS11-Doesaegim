//
//  CustomCalendarCellViewModel.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/28.
//

import Foundation

final class CustomCalendarCellViewModel: CustomCalendarCellProtocol {
    weak var delegate: CustomCalendarCellDelegate?
    
    var isSunday: Bool {
        didSet {
            delegate?.changeLabelColor(isSunday: isSunday)
        }
    }
    
    init() {
        self.isSunday = false
    }
    
    
    func checkDateIsSunday(to date: Date) {
        let calendar = Calendar.current
        let week = calendar.component(.weekday, from: date)
        isSunday = week == 2
    }
    
}
