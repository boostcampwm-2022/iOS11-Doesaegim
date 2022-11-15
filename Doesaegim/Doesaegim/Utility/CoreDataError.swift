//
//  CoreDataError.swift
//  Doesaegim
//
//  Created by sun on 2022/11/16.
//

import Foundation

enum CoreDataError {
    case fetchFailure
    case saveFailure
    case deleteFailure
}

extension CoreDataError: CustomStringConvertible {

    var description: String {
        switch self {
        case .fetchFailure:
            return "정보를 불러오는 데 실패했습니다"
        case .saveFailure:
            return "변경사항을 저장하는 데 실패했습니다"
        case .deleteFailure:
            return "정보를 삭제하는 데 실패했습니다"
        }
    }
}
