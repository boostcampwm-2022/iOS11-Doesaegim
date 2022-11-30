//
//  BarShapeLayer.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/30.
//

import UIKit

final class BarShapeLayer: CAShapeLayer {
    
    // MARK: - Properties
    
    private let rect: CGRect
    
    private let color: CGColor
    
    private let value: CGFloat
    
    // MARK: - Init
    
    init(rect: CGRect, color: CGColor, value: CGFloat) {
        self.rect = rect
        self.color = color
        self.value = value
        
        super.init()
        
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Functions
    
    private func configure() {
        configurePath()
        configureAttributes()
    }
    
    private func configurePath() {
        let barPath = UIBezierPath()
        
        barPath.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        barPath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - value))
        
        UIColor.clear.set()
        barPath.stroke()
        
        path = barPath.cgPath
    }
    
    private func configureAttributes() {
        lineWidth = min(rect.width * Metric.widthRatio, Metric.defaultBarWidth)
        strokeColor = color
    }
    
    // MARK: - Animation Functions
    
    func addAnimation() {
        let animation = CABasicAnimation(keyPath: StringLiteral.animationKey)
        animation.fromValue = Metric.animationFromValue
        animation.toValue = Metric.animationToValue
        animation.duration = Metric.animationDuration
        
        add(animation, forKey: animation.keyPath)
    }
}

extension BarShapeLayer {
    enum Metric {
        static let defaultBarWidth: CGFloat = 70
        static let widthRatio: CGFloat = 0.7
        
        static let animationFromValue: CGFloat = 0
        static let animationToValue: CGFloat = 1
        static let animationDuration: CGFloat = 1
    }
    
    enum StringLiteral {
        static let animationKey = "strokeEnd"
    }
}
