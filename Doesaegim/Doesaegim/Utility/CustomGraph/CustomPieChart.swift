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
    
    /// 주어진 rect에 맞게 원형 차트를 그린다. 원형 차트는 정원 형태로영역에 꽉 채워서 그려진다.
    /// - Parameter rect: 원형 차트를 그릴 영역.
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        var startAngle: CGFloat = Metric.initialStartAngle
        
        for idx in items.indices {
            let ratio = drawOnePieceOfPie(
                center: center,
                radius: rect.width/2,
                start: startAngle,
                item: items[idx]
            )
            
            startAngle += ratio
        }
        
    }
    
    /// 주어진 비율에 맞게 원형 차트의 한 조각을 그린다.
    private func drawOnePieceOfPie(
        center: CGPoint,
        radius: CGFloat,
        start startAngle: CGFloat,
        item: CustomChartItem
    ) -> CGFloat {
        let ratio = (item.value / total) * Metric.angleRatio
        
        let path = UIBezierPath()
        path.lineWidth = Metric.pieChartSpacing
        
        path.move(to: center)
        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: startAngle, 
            endAngle: startAngle + ratio,
            clockwise: true
        )
        path.close()
        
        item.category.color.set()
        path.fill()
        
        UIColor.systemBackground.set()
        path.stroke()
        
        return ratio
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
        static let pieChartSpacing: CGFloat = 5
        static let pieChartRadius: CGFloat = 70
        
        static let initialStartAngle: CGFloat = (.pi) * 3 / 2
        
        static let angleRatio: CGFloat = .pi * 2
    }
}
