//
//  CustomChartType.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/12/04.
//

import Foundation

enum CustomChartType: Int, CaseIterable {
    case pie, bar
    
    var title: String {
        switch self {
        case .pie: return "카테고리별"
        case .bar: return "날짜별"
        }
    }
}
