//
//  PieceTextLayer.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/21.
//

import UIKit

final class PieceTextLayer: CATextLayer {
    
    // MARK: - Properties
    
    /// 파이 차트의 중심값
    private let center: CGPoint
    
    /// 파이 조각이 그려진 영역 값
    private let pieceBounds: CGRect
    
    /// 파이 조각에 표시할 텍스트
    private let text: String
    
    // MARK: - Init
    
    init(center: CGPoint, pieceBounds: CGRect, text: String) {
        self.center = center
        self.pieceBounds = pieceBounds
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
        let spacing = CGPoint(
            x: pieceBounds.width * 0.1,
            y: pieceBounds.height * 0.1
        )
        let xPosition = configureXPosition(with: spacing.x)
        let yPosition = configureYPosition(with: spacing.y)
        
        let textFrame = CGRect(
            x: xPosition,
            y: yPosition,
            width: Metric.textWidth,
            height: fontSize * 2
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
    
    // TODO: configureXPosition, configureYPosition 겹치는 부분 합치고 싶은데 가능할까..
    
    /// 텍스트가 표시될 위치의 x 좌표 값을 구해 반환한다.
    /// - Parameter spacing: 파이 차트 중심에서 떨어질 정도 값
    /// - Returns: 텍스트가 표시될 x 좌표 값
    private func configureXPosition(with spacing: CGFloat) -> CGFloat {
        let leftSide: CGFloat = abs(center.x - pieceBounds.minX)
        let rightSide: CGFloat = abs(center.x - pieceBounds.maxX)
        
        let baseXPosition = leftSide < rightSide ? pieceBounds.midX : pieceBounds.minX
        let multiplier: CGFloat = leftSide < rightSide ? 1 : -1
        
        return baseXPosition + multiplier * spacing
    }
    
    /// 텍스트가 표시될 위치의 y 좌표 값을 구해 반환한다.
    /// - Parameter spacing: 파이 차트 중심에서 떨어질 정도 값
    /// - Returns: 텍스트가 표시될 y 좌표 값
    private func configureYPosition(with spacing: CGFloat) -> CGFloat {
        let topSide: CGFloat = abs(center.y - pieceBounds.minY)
        let bottomSide: CGFloat = abs(center.y - pieceBounds.maxY)
        
        let baseYPosition = topSide < bottomSide ? pieceBounds.midY : pieceBounds.minY
        let multiplier: CGFloat = topSide < bottomSide ? -1 : 1
        print(multiplier)
        
        return baseYPosition + multiplier * spacing
    }
}

extension PieceTextLayer {
    enum Metric {
        static let textWidth: CGFloat = 60
        static let textFontSize: CGFloat = 16
    }
}
