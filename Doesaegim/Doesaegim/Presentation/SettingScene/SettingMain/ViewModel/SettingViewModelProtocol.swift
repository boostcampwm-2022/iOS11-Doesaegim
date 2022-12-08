//
//  SettingViewModelProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/07.
//

import UIKit


protocol SettingViewModelProtocol {
    
    var delegate: SettingViewModelDelegate? { get set }
    var settingInfos: [SettingSection] { get set }
    
    func configureSettingInfos()
    
}

protocol SettingViewModelDelegate {
    
    func settingViewCellDidTapped(moveTo controller: UIViewController)
        
}
