//
//  CoreDataError.swift
//  Doesaegim
//
//  Created by sun on 2022/11/16.
//

import Foundation

enum CoreDataError: LocalizedError {
    case fetchFailure
    case saveFailure
    case deleteFailure

    var errorDescription: String? {
        switch self {
        case .fetchFailure:
            return NSLocalizedString("정보를 불러오는 데 실패했습니다", comment: "fetch failure")
        case .saveFailure:
            return NSLocalizedString("변경사항을 저장하는 데 실패했습니다", comment: "save failure")
        case .deleteFailure:
            return NSLocalizedString("정보를 삭제하는 데 실패했습니다", comment: "delete failure")
        }
    }
}
