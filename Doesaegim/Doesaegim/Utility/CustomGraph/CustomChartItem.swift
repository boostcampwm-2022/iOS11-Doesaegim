//
//  CustomChartItem.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/21.
//

import Foundation

struct CustomChartItem<T: Equatable>: Equatable {
    
    /// 차트데이터를 구분 짓는 기준이 되는 값.
    /// 원형 차트에서는 ExpenseType이, 막대 차트에서는 Date가 기준이 된다.
    let criterion: T
    
    /// 차트 데이터 값
    var value: CGFloat
    
    init(criterion: T, value: CGFloat) {
        self.criterion = criterion
        self.value = value
    }
}
