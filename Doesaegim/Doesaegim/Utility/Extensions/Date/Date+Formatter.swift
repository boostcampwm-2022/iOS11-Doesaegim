//
//  Date+TravelString.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/15.
//

import Foundation

extension Date {

    // MARK: - Properties
    
    static let yearMonthDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        return formatter
    }()
    
    static let yearTominuteFormatterWithoutSeparator: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        
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
    
    static let yearMonthDaySplitDashDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    static let onlyDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()

    /// 날짜를 22.11.16(수) 형태로 표현한 문자열
    var shortYearMonthDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd(E)"

        return formatter.string(from: self)
    }


    // MARK: - Functions
    
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
    
    static func convertDateStringToDate(dateString: String, formatter: DateFormatter) -> Date? {
        return formatter.date(from: dateString)
    }
    
    /// 오늘날짜를 yyyy-MM-dd 문자열로 반환하는 메서드
    /// - Returns: yyyy-MM-dd 형식 오늘 날짜 문자열
    static func todayDateConvertToString() -> String {
        let day = Date()
        let formatter = Date.yearMonthDaySplitDashDateFormatter
        return formatter.string(from: day)
    }
    
    /// 어제날짜를 yyyy-MM-dd 문자열로 반환하는 메서드
    /// - Returns: yyyy-MM-dd 형식 어제 날짜 문자열
    static func yesterDayDateConvertToString() -> String {
        let calendar: Calendar = .current
        let yesterday =  calendar.date(byAdding: .day, value: -1, to: Date())
        let formatter = Date.yearMonthDaySplitDashDateFormatter
        return formatter.string(from: yesterday ?? Date(timeIntervalSinceNow: 60 * 60 * 24 * -1))
    }
}
