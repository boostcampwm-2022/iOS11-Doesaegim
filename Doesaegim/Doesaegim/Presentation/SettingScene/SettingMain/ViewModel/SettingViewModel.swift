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
                    .staticCell(
                        model: SettingOptionViewModel(
                            title: "날짜/시간표시",
                            icon: UIImage(systemName: "calendar"),
                            iconTintColor: .primaryOrange,
                            handler: {
                                print("날짜/시간표시 셀 선택")
                            }
                        )
                    ),
                    
                    .switchCell(
                        model: SettingOptionViewModel(
                            title: "알림받기",
                            icon: UIImage(systemName: "bell"),
                            iconTintColor: .primaryOrange,
                            handler: {
                                print("알림설정 셀 선택")
                            }
                        )
                    )
                ]
            ),
            SettingSection(
                
                title: "애플리케이션",
                options: [
                    .staticCell(
                        model: SettingOptionViewModel(
                            title: "라이센스",
                            icon: UIImage(systemName: "text.book.closed"),
                            iconTintColor: .primaryOrange,
                            handler: {
                                // TODO: - 라이센스 화면으로 이동 -> delegate 메서드 사용
                                print("라이센스 셀 선택")
                            }
                        )
                    )
                ]
            )
        ]
        // 배열 삽입 끝
    }
    
}

struct SettingSection {
    let title: String
    let options: [SettingOptionType]
}
