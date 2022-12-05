//
//  PieceShapeLayer.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/21.
//

import UIKit

final class PieceShapeLayer: CAShapeLayer {
    
    // MARK: - Properties
    
    private let center: CGPoint
    
    private let radius: CGFloat
    
    private let startAngle: CGFloat
    
    private let angle: CGFloat
    
    private let color: CGColor
    
    // MARK: - Computed Properties
    
    private var strokeWidth: CGFloat { radius * 2 }
    
    // MARK: - Init
    
    init(center: CGPoint, radius: CGFloat, startAngle: CGFloat, angle: CGFloat, color: CGColor) {
        self.center = center
        self.radius = radius
        self.startAngle = startAngle
        self.angle = angle
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
            endAngle: startAngle + angle,
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
