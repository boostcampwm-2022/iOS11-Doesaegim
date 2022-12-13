//
//  SettingViewModelProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/07.
//

import UIKit


protocol SettingViewModelProtocol: AnyObject{
    
    var delegate: SettingViewModelDelegate? { get set }
    var settingInfos: [SettingSection] { get set }
    
    func configureSettingInfos()
    
}

protocol SettingViewModelDelegate: AnyObject{
    
    func settingViewCellDidTap(moveTo controller: UIViewController)
    func settingPersonalInformationProcessingDidTap()
    func settingInquiryDidTap()
    func settingAlertDidTap()
        
}
