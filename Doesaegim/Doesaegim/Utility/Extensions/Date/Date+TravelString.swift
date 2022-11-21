//
//  Date+TravelString.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/15.
//

import Foundation

extension Date {
    
    static let yearMonthDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        return formatter
    }()
    
    static let monthDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        
        return formatter
    }()
    
    static let yearMonthDayTimeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
        
        return formatter
    }()
    
    static let timeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh시 mm분"
        
        return formatter
    }()
    
    static let yearMonthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        
        return formatter
    }()
    
    /// 시작일 Date인스턴스와 종료일 Date 인스턴스를 받아 여행 목록시 부제목으로 사용되는 문자열을 반환한다.
    /// - Parameters:
    ///   - start: 시작일 `Date`인스턴스
    ///   - end: 종료일 `Date`인스턴스
    /// - Returns: OOOO년 OO월 OO일 ~ OO월 OO일 형식의 문자열
    static func convertTravelString(start: Date, end: Date) -> String {
        let startDateFormatter = Date.yearMonthDayDateFormatter
        let endDateFormatter = Date.monthDayDateFormatter
        
        let startDateString = startDateFormatter.string(from: start)
        let endDateString = endDateFormatter.string(from: end)
        let periodString = startDateString + " ~ " + endDateString

        return periodString
    }
}
