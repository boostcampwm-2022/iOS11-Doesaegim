//
//  TemporaryDiary.swift
//  Doesaegim
//
//  Created by sun on 2022/11/22.
//

import Foundation

/// DiaryAddViewModel에서 임시로 값을 들고 있기 위한 구조체
struct TemporaryDiary {
    let id = UUID()
    // TODO: 날짜도 입력창에서 선택할 수 있게 해야될듯
    let date = Date()
    var travel: Travel?
    var location: LocationDTO?
    var title: String?
    var content: String?
    var images: [String]?

    /// 필수 항목(여행, 장소, 제목, 내용)이 작성되었는 지 여부
    var requiredPropertiesAreFilled: Bool {
        travel != nil && location != nil && title?.isEmpty == false && content?.isEmpty == false
    }
}
