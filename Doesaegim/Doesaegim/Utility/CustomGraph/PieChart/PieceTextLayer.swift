//
//  PieceTextLayer.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/21.
//

import UIKit

final class PieceTextLayer: CATextLayer {
    
    // MARK: - Properties
    
    /// 파이 차트의 영역값
    private let rect: CGRect
    
    /// 텍스트를 표시할 조각의 시작 지점 각도
    private let startAngle: CGFloat
    
    /// 텍스트를 표시할 조각의 자체 각도.
    private let angle: CGFloat
    
    /// 파이 조각에 표시할 텍스트
    private let text: String
    
    // MARK: - Computed Properties
        
    private var center: CGPoint {
        return CGPoint(x: rect.midX, y: rect.midY)
    }
    
    private var radius: CGFloat {
        let diameter = min(rect.width, rect.height)
        return diameter * Metric.radiusRatio
    }
    
    // MARK: - Init
    
    init(rect: CGRect, startAngle: CGFloat, angle: CGFloat, text: String) {
        self.rect = rect
        self.startAngle = startAngle
        self.angle = angle
        self.text = text
        
        super.init()
        
        configureFrame()
        configureText()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure Functions
    
    /// 표시할 텍스트 레이어의 위치, 크기를 지정한다.
    private func configureFrame() {
        let textPosition = configurePosition()
        let textSize = CGSize(width: Metric.textWidth, height: fontSize * 1.5)
        
        let textFrame = CGRect(
            origin: CGPoint(
                x: textPosition.x - textSize.width / 2,
                y: textPosition.y - textSize.height / 2
            ),
            size: textSize
        )
        frame = textFrame
    }
    
    /// 표시할 텍스트의 크기, 색상을 지정한다.
    private func configureText() {
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: Metric.textFontSize),
                .foregroundColor: UIColor.white ?? UIColor()
            ]
        )
        string = attributedString
        alignmentMode = .left
    }
    
    /// 파이 조각의 중간 위치 값을 구해 반환한다. 해당 위치는 텍스트의 midX, midY 좌표값이 된다.
    private func configurePosition() -> CGPoint {
        let halfAngle: CGFloat = startAngle + angle / 2
        
        let xCoordinate = center.x + cos(halfAngle) * radius * Metric.positionRatio
        let yCoordinate = center.y + sin(halfAngle) * radius * Metric.positionRatio
        
        return CGPoint(x: xCoordinate, y: yCoordinate)
    }
    
}

extension PieceTextLayer {
    enum Metric {
        static let radiusRatio: CGFloat = 0.4

        static let textWidth: CGFloat = 60
        static let textFontSize: CGFloat = 16
        
        static let positionRatio: CGFloat = 0.7
    }
}
