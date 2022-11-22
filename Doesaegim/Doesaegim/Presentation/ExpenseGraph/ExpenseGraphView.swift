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
        CustomChartItem(category: .transport, value: 50),
        CustomChartItem(category: .lodgment, value: 60),
        CustomChartItem(category: .etc, value: 20)
    ]

    // MARK: - Init
    
    init(data: [CustomChartItem], frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.data = data
        self.isBlur = false
        configureViews()
    }
    
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
        if isBlur { configureBlurEffect() }
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
    
    private func configureBlurEffect(style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(visualEffectView)
    }
}
