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
                selectedOption: UserDefaults.standard.integer(
                    forKey: UserDefaultsKey.CalendarInfoKey.yearMonthDateFormat.rawValue
                ),
                options: [
                    CalendarViewModel(title: "yyyy년 mm월 dd일", handler: {
                        
                    }),
                    CalendarViewModel( title: "yyyy/mm/dd", handler: {
                        
                    }),
                    CalendarViewModel( title: "mm/dd/yyyy", handler: {
                        
                    }),
                ]
            ),
            CalendarSection(
                title: "시간 표시",
                selectedOption: UserDefaults.standard.integer(
                    forKey: UserDefaultsKey.CalendarInfoKey.timeFormat.rawValue
                ),
                options: [
                    CalendarViewModel(title: "AM/PM", handler: {
                        
                    }),
                    CalendarViewModel(title: "24시간", handler: {
                        
                    })
                ]
            )
        ]
        
    }
    
    func changeSelectedState(with indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        var newInfos = calendarSettingInfos
        newInfos[section].selectedOption = row
        calendarSettingInfos = newInfos
        
        // 선택된 정보를 UserDefaults에 등록
        switch section {
        case 0:
            
            UserDefaults.standard.set(
                row,
                forKey: UserDefaultsKey.CalendarInfoKey.yearMonthDateFormat.rawValue
            )
            
        case 1:
            UserDefaults.standard.set(
                row,
                forKey: UserDefaultsKey.CalendarInfoKey.timeFormat.rawValue
            )
            
        default:
            print("잘못된 접근입니다.")
        }
    }
}

struct CalendarSection {
    let title: String
    var selectedOption: Int
    var options: [CalendarViewModel]
}
