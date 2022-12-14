//
//  CoreDataError.swift
//  Doesaegim
//
//  Created by sun on 2022/11/16.
//

import Foundation

enum CoreDataError: LocalizedError {
    case fetchFailure(EntityType)
    case saveFailure(EntityType)
    case deleteFailure(EntityType)
    case updateFailure(EntityType)

    var errorDescription: String? {
        switch self {
        case .fetchFailure(let entityType):
            return NSLocalizedString("\(entityType) 정보를 불러오는 데 실패했습니다", comment: "fetch failure")
        case .saveFailure(let entityType):
            return NSLocalizedString("\(entityType) 변경사항을 저장하는 데 실패했습니다", comment: "save failure")
        case .deleteFailure(let entityType):
            return NSLocalizedString("\(entityType) 정보를 삭제하는 데 실패했습니다", comment: "delete failure")
        case .updateFailure(let entityType):
            return NSLocalizedString("\(entityType) 정보를 수정하는 데 실패했습니다", comment: "delete failure")
        }
    }
}

enum EntityType: String, CustomStringConvertible {
    case travel
    case expense
    case location
    case plan
    case diary

    var description: String {
        self.rawValue.capitalized
    }
}
