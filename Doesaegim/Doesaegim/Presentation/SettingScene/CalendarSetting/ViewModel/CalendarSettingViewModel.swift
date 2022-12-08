//
//  CalendarSettingViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/08.
//

import Foundation


final class CalendarSettingViewModel: CalendarSettingViewModelProtocol {
    
    var delegate: CalendarSettingViewModelDelegate?
    var calendarSettingInfos: [CalendarSection] {
        didSet {
            delegate?.calendarSettingDidChange()
        }
    }
    
    init() {
        self.calendarSettingInfos = []
    }
    
}

extension CalendarSettingViewModel {
    
    func configureCalendarSettingInfos() {
        
        calendarSettingInfos = [
            CalendarSection(
                title: "날짜 표시",
                selectedOption: UserDefaults.standard.object(
                    forKey: CalendarInfoKey.yearMonthDateFormat.rawValue
                ) as? Int ?? 0,
                options: [
                    CalendarViewModel(title: "yyyy년 mm월 dd일", handler: {
                        print("yyyy년 mm월 dd일")
                    }),
                    CalendarViewModel( title: "yyyy/mm/dd", handler: {
                        print("yyyy/mm/dd")
                    }),
                    CalendarViewModel( title: "mm/dd/yyyy", handler: {
                        print("mm/dd/yyyy")
                    }),
                ]
            ),
            CalendarSection(
                title: "시간 표시",
                selectedOption: UserDefaults.standard.object(
                    forKey: CalendarInfoKey.timeFormat.rawValue
                ) as? Int ?? 0,
                options: [
                    CalendarViewModel(title: "AM/PM", handler: {
                        print("AM/PM표기법")
                    }),
                    CalendarViewModel(title: "24시간", handler: {
                        print("24시간")
                    })
                ]
            )
        ]
        
    }
    
}

struct CalendarSection {
    let title: String
    var selectedOption: Int
    var options: [CalendarViewModel]
}

enum CalendarInfoKey: String {
    case yearMonthDateFormat
    case timeFormat
}
