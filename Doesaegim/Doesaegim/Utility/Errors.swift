//
//  Errors.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/21.
//

import Foundation

enum Errors: Error, LocalizedError {
    case canNotGetTravelDataException
    case canNotGetExpenseDataException
    
    var errorDescription: String? {
        switch self {
        case .canNotGetTravelDataException:
            print("Travel 데이터를 영구저장소로부터 가져올 수 없습니다.")
        case .canNotGetExpenseDataException:
            print("Travel 데이터를 영구저장소로부터 가져올 수 없습니다.")
        }
    }
}
