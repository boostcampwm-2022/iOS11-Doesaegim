//
//  ImageStatus.swift
//  Doesaegim
//
//  Created by sun on 2022/11/24.
//

import UIKit

enum ImageStatus {
    case inProgress(Progress)
    case complete(UIImage?)
    case error(UIImage?)
    case dummy
}
