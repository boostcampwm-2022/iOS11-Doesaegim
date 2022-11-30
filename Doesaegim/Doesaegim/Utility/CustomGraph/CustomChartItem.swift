//
//  CustomChartItem.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/21.
//

import Foundation

struct CustomChartItem {
    let category: ExpenseType?
    let date: Date?
    
    /// 차트 데이터 값
    var value: CGFloat
    
    init(category: ExpenseType? = nil, date: Date? = nil, value: CGFloat) {
        self.category = category
        self.date = date
        self.value = value
    }
}
