//
//  UserDefaultsKey.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/12.
//

import Foundation


enum UserDefaultsKey {
    
    // TODO: - 추후 알림의 종류(메세지, 푸시알림, 이메일 등...)가 많아지면 더 추가
    enum AlertInfoKey: String {
        case isAlertOn
    }
    
    enum CalendarInfoKey: String {
        case yearMonthDateFormat
        case timeFormat
    }
    
}
