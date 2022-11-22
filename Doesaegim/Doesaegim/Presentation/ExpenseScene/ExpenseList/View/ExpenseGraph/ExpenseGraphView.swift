//
//  ExpenseGraphView.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/22.
//

import UIKit

import SnapKit

class ExpenseGraphView: UIView {
    
    // MARK: - UI Properties
    
    private lazy var chart = CustomPieChart(items: data)
    
    // MARK: - Properties
    
    private var isBlur: Bool = true
    
    private var data: [CustomChartItem] = [
        CustomChartItem(category: .food, value: 70),
        CustomChartItem(category: .shopping, value: 30),
        CustomChartItem(category: .transportation, value: 50),
        CustomChartItem(category: .room, value: 60),
        CustomChartItem(category: .other, value: 20)
    ]

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup Functions
    
    func setupChartData(_ data: [CustomChartItem]) {
        if !data.isEmpty { self.data = data }
        isBlur = data.isEmpty
        
        configureViews()
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraint()
        if isBlur { configureBlurEffect() }
    }
    
    private func configureSubviews() {
        addSubview(chart)
    }
    
    private func configureConstraint() {
        chart.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Metric.chartInsets)
        }
    }
    
    private func configureBlurEffect(style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(visualEffectView)
    }
}

extension ExpenseGraphView {
    enum Metric {
        static let chartInsets: CGFloat = 46
    }
}
