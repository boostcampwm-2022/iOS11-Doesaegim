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
    var date: Date?
    var travel: Travel?
    var location: LocationDTO?
    var title: String?
    var content: String?
    var imagePaths = [String]()

    /// 필수 항목(여행, 장소, 날짜, 제목, 내용)이 작성되었는 지 여부
    var hasAllRequiredProperties: Bool {
        let hasTravel = travel != nil
        let hasLocation = location != nil
        let hasDate = date != nil
        let hasTitle = title?.isEmpty == false
        let hasContent = content?.isEmpty == false

        return hasTravel && hasLocation && hasDate && hasTitle && hasContent
    }

    var dateString: String {
        if travel == nil {
            return "여행을 먼저 선택해 주세요."
        }

        guard let date
        else {
            return "날짜와 시간을 입력해 주세요."
        }

        return Date.yearMonthDayTimeDateFormatter.string(from: date)
    }
}
