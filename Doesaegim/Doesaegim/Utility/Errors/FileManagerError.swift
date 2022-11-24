//
//  FilManagerError.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/23.
//

import Foundation


enum FileManagerError: LocalizedError {
    case fetchFailure(FileType)
    
    var errorDescription: String? {
        switch self {
        case .fetchFailure(let fileType):
            return "\(fileType)을 가져오는데 실패하였습니다."
        }
    }
}

enum FileType: String, CustomStringConvertible {
    case image
    
    var description: String {
        return self.rawValue.capitalized
    }
}
