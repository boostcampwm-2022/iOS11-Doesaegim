//
//  CustomPieChart.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/17.
//

import UIKit

import SnapKit

/// Custom Pie Chart
final class CustomPieChart: UIView {
    
    // MARK: - Properties
    
    private var items: [CustomChartItem] = []
    
    private var total: CGFloat {
        items.reduce(0) { $0 + $1.value }
    }
    
    // MARK: - Init
    
    /// 원형 차트를 그릴 기반이 되는 데이터 값의 배열을 받아 차트 화면을 생성한다.
    /// - Parameters:
    ///   - data: 차트 데이터 값의 배열 (추후 카테고리 정보를 함께 받아 색도 함께 지정해줘야함)
    convenience init(
        items: [CustomChartItem],
        frame: CGRect = .zero
    ) {
        self.init(frame: frame)
        self.items = items
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureBackgroundColor()
    }
    
    // MARK: - Draw Functions
    
    /// 주어진 rect에 맞게 원형 차트를 그린다. 원형 차트는 정원 형태로 영역에 꽉 채워서 그려진다.
    /// - Parameter rect: 원형 차트를 그릴 영역.
    override func draw(_ rect: CGRect) {
        var startAngle: CGFloat = Metric.initialStartAngle
        
        for idx in items.indices {
            let ratio = (items[idx].value / total) * Metric.angleRatio
            let pieceLayer = PieceLayer(
                rect: rect,
                start: startAngle,
                ratio: ratio,
                color: items[idx].category.color.cgColor
            )
            
            let textRect = rect
            let textLayer = PieceTextLayer(
                rect: textRect,
                text: items[idx].category.description
            )
            
            layer.addSublayer(pieceLayer)
            layer.addSublayer(textLayer)
            
            startAngle += ratio
        }

    }
    
    // MARK: - Configure Functions
    
    /// 차트 뷰의 배경색 지정
    private func configureBackgroundColor() {
        backgroundColor = .systemBackground
    }
    
}

// MARK: - Namespaces

extension CustomPieChart {
    enum Metric {
        static let initialStartAngle: CGFloat = (.pi) * 3 / 2
        static let angleRatio: CGFloat = .pi * 2
    }
}
