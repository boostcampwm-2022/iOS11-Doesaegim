//
//  CalendarSettingViewModelProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/08.
//

import Foundation


protocol CalendarSettingViewModelProtocol: AnyObject {
    
    var delegate: CalendarSettingViewModelDelegate? { get set }
    var calendarSettingInfos: [CalendarSection] { get set }
    
    func configureCalendarSettingInfos()
    func changeSelectedState(with indexPath: IndexPath)
    
}

protocol CalendarSettingViewModelDelegate: AnyObject {
    
    func calendarSettingDidChange()
    
}
