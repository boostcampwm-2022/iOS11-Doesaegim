//
//  Date+TravelString.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/15.
//

import Foundation

extension Date {

    // MARK: - Enums

    private enum LocaleIdentifier {
        static let korea = "ko"
    }

    // MARK: - Properties
    
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
    
    static let yearTominuteFormatterWithoutSeparator: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmSS"
        
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

    var userDefaultFormattedDate: String {
        let formatter = Date.convertYearToDayFormatter(with: self)
        formatter.locale = Locale(identifier: LocaleIdentifier.korea)
        formatter.dateFormat += " (E)"

        return formatter.string(from: self)
    }

    var userDefaultFormattedTime: String {
        let formatter = Date.convertHourToMinuteFormatter(with: self)
        formatter.locale = Locale(identifier: LocaleIdentifier.korea)

        return formatter.string(from: self)
    }


    // MARK: - Functions
    
    /// 시작일 Date인스턴스와 종료일 Date 인스턴스를 받아 여행 목록시 부제목으로 사용되는 문자열을 반환한다.
    /// - Parameters:
    ///   - start: 시작일 `Date`인스턴스
    ///   - end: 종료일 `Date`인스턴스
    /// - Returns: OOOO년 OO월 OO일 ~ OO월 OO일 형식의 문자열
    static func convertTravelString(start: Date, end: Date) -> String {
        let startDateFormatter = Date.convertYearToDayFormatter(with: start)
        let endDateFormatter = Date.convertMonthToDayFormatter(with: end)
        
        let startDateString = startDateFormatter.string(from: start)
        let endDateString = endDateFormatter.string(from: end)
        let periodString = startDateString + " ~ " + endDateString

        return periodString
    }
    
    static func convertYearToDayFormatter(with date: Date) -> DateFormatter {
        
        let formatter = DateFormatter()
        guard let formatterState = UserDefaults.standard.object(
            forKey: UserDefaultsKey.CalendarInfoKey.yearMonthDateFormat.rawValue
        ) as? Int else {
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter
        }
        
        switch formatterState {
        case 0:
            formatter.dateFormat = "yyyy년 MM월 dd일"
        case 1:
            formatter.dateFormat = "yyyy/MM/dd"
        case 2:
            formatter.dateFormat = "MM/dd/yyyy"
        default:
            print("잘못된 형식입니다.")
        }
        
        return formatter
        
    }
    
    static func convertMonthToDayFormatter(with date: Date) -> DateFormatter {
        
        let formatter = DateFormatter()
        guard let formatterState = UserDefaults.standard.object(
            forKey: UserDefaultsKey.CalendarInfoKey.yearMonthDateFormat.rawValue
        ) as? Int else {
            formatter.dateFormat = "MM월 dd일"
            return formatter
        }
        
        switch formatterState {
        case 0:
            formatter.dateFormat = "MM월 dd일"
        case 1, 2:
            formatter.dateFormat = "MM/dd"
        default:
            print("잘못된 형식입니다.")
        }
        
        return formatter
        
    }
    
    static func convertHourToMinuteFormatter(with date: Date) -> DateFormatter {
        
        let formatter = DateFormatter()
        guard let formatterState = UserDefaults.standard.object(
            forKey: UserDefaultsKey.CalendarInfoKey.timeFormat.rawValue
        ) as? Int else {
            formatter.dateFormat = "HH:mm"
            return formatter
        }
        
        switch formatterState {
        case 0:
            formatter.dateFormat = "a HH:mm"
            formatter.timeStyle = .short
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
        case 1:
            formatter.dateFormat = "HH:mm"
        default:
            print("잘못된 형식입니다.")
        }
        
        return formatter
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
