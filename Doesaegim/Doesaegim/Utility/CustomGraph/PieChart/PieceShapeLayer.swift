//
//  PieceShapeLayer.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/21.
//

import UIKit

final class PieceShapeLayer: CAShapeLayer {
    
    // MARK: - Properties
    
    private let rect: CGRect
    
    private let startAngle: CGFloat
    
    private let angleRatio: CGFloat
    
    private let color: CGColor
    
    // MARK: - Computed Properties
    
    private var center: CGPoint {
        return CGPoint(x: rect.midX, y: rect.midY)
    }
    
    private var radius: CGFloat {
        // 차트뷰가 그려질 뷰의 너비, 높이값이 다를 경우 차트뷰의 지름은 작은 값을 따라간다.
        let diameter = min(rect.width, rect.height)
        return diameter * Metric.radiusRatio
    }
    
    private var strokeWidth: CGFloat {
        return radius * 2
    }
    
    // MARK: - Init
    
    init(rect: CGRect, startAngle: CGFloat, angleRatio: CGFloat, color: CGColor) {
        self.rect = rect
        self.startAngle = startAngle
        self.angleRatio = angleRatio
        self.color = color
        
        super.init()
        
        configurePath()
        configureAttributes()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Functions
    
    /// 레이어의 path를 지정한다. 원형 차트의 조각을 여기서 그린다.
    private func configurePath() {
        let piecePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: startAngle + angleRatio,
            clockwise: true
        )
        UIColor.clear.set()
        piecePath.stroke()
        
        path = piecePath.cgPath
    }
    
    /// 레이어의 속성값을 지정한다.
    private func configureAttributes() {
        lineWidth = strokeWidth
        strokeColor = color
        fillColor = UIColor.clear.cgColor
    }
}

// MARK: - Namespaces

extension PieceShapeLayer {
    enum Metric {
        static let spacing: CGFloat = 5
        static let radiusRatio: CGFloat = 0.23
    }
}
