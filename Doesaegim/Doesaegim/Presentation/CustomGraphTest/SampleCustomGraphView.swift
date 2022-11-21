//
//  SampleCustomGraphView.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/17.
//

import UIKit

import SnapKit

class SampleCustomGraphView: UIView {
    
    // MARK: - Properties
    
    private let chart = CustomPieChart(
        items: [
            CustomChartItem(category: .food, value: 70),
            CustomChartItem(category: .shopping, value: 30),
            CustomChartItem(category: .transport, value: 50),
            CustomChartItem(category: .lodgment, value: 60),
            CustomChartItem(category: .etc, value: 20)
        ]
    )

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViews()
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraint()
    }
    
    private func configureSubviews() {
        addSubview(chart)
    }
    
    private func configureConstraint() {
        chart.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }
}
