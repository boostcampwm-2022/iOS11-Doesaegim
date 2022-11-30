//
//  CustomChartItem.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/21.
//

import Foundation

struct CustomChartItem {
    // TODO: 막대 차트에서도 사용할 거라면 category 대신 다른 걸 사용해야함. 막대 차트는 카테고리 기준이 아니니까..!
    let category: ExpenseType
    
    /// 차트 데이터 값
    var value: CGFloat
    
    init(category: ExpenseType, value: CGFloat) {
        self.category = category
        self.value = value
    }
}
