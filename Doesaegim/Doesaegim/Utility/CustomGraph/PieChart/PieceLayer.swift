//
//  CustomPiePieceLayer.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/21.
//

import UIKit

final class PieceLayer: CAShapeLayer {
    
    // MARK: - Properties
    
    private let rect: CGRect
    
    private let startAngle: CGFloat
    
    private let angleRatio: CGFloat
    
    private let color: CGColor
    
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
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width/2
        
        let piecePath = UIBezierPath()
        piecePath.lineWidth = Metric.spacing
        
        piecePath.move(to: center)
        piecePath.addArc(
            withCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: startAngle + angleRatio,
            clockwise: true
        )
        piecePath.close()
        
        path = piecePath.cgPath
    }
    
    /// 레이어의 속성값을 지정한다.
    private func configureAttributes() {
        lineWidth = Metric.spacing
        strokeColor = UIColor.systemBackground.cgColor
        fillColor = color
    }
}

// MARK: - Namespaces

extension PieceLayer {
    enum Metric {
        static let spacing: CGFloat = 5
    }
}
