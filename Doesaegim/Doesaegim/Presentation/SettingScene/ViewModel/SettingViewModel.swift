//
//  SettingViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/07.
//

import UIKit


final class SettingViewModel: SettingViewModelProtocol {
    
    var settingInfos: [SettingOptionViewModel] = [SettingOptionViewModel]()
    
}

// MARK: - Functions

extension SettingViewModel {
    
    func configureSettingInfos() {
        // 배열 삽입 시작
        settingInfos = [
            SettingOptionViewModel(
                title: "날짜/시간표시",
                icon: UIImage(systemName: "house"),
                iconTintColor: .primaryOrange, handler: {
                    print("SET SETTING OPTION VIEWMODEL")
                }
            ),
            SettingOptionViewModel(
                title: "알림설정",
                icon: UIImage(systemName: "bell"),
                iconTintColor: .primaryOrange,
                handler: {
                    print("SET SETTING OPTION VIEWMODEL")
                }
            )
        ]
        // 배열 삽입 끝
    }
    
}
