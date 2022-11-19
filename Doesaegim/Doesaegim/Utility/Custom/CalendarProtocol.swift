//
//  CalendarProtocol.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/17.
//

import Foundation

protocol CalendarProtocol: AnyObject {
    var delegate: CalendarViewDelegate? { get set }
}

protocol CalendarViewDelegate: AnyObject {
    func fetchDate(dateString: String)
}
