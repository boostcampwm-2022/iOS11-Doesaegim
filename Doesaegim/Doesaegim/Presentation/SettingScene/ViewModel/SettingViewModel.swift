//
//  SettingViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/07.
//

import UIKit


final class SettingViewModel: SettingViewModelProtocol {
    
    var settingInfos: [SettingSection] = [SettingSection]()
    
}

// MARK: - Functions

extension SettingViewModel {
    
    func configureSettingInfos() {
        // 배열 삽입 시작
        settingInfos = [
            SettingSection(
                title: "사용설정",
                options: [
                    SettingOptionViewModel(
                        title: "날짜/시간표시",
                        icon: UIImage(systemName: "calendar"),
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
            ),
            SettingSection(
                title: "애플리케이션",
                options: [
                    SettingOptionViewModel(
                        title: "라이센스",
                        icon: UIImage(systemName: "text.book.closed"),
                        iconTintColor: .primaryOrange, handler: {
                            print("SET SETTING OPTION VIEWMODEL")
                        }
                    )
                ]
            )
        ]
        // 배열 삽입 끝
    }
    
}
