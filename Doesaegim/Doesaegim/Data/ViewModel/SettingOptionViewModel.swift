//
//  SettingOptionViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/07.
//

import UIKit


struct SettingOptionViewModel {
    
    let title: String
    let icon: UIImage?
    let iconTintColor: UIColor?
    let handler: (() -> Void)
    
}

enum SettingOptionType {
    case staticCell(model: SettingOptionViewModel)
    case switchCell(model: SettingOptionViewModel)
}
