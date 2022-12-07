//
//  BarBackgroundLayer.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/30.
//

import UIKit

final class BarBackgroundLayer: CAShapeLayer {
    
    // MARK: - Properties
    
    private let rect: CGRect
    
    private let inset: CGSize
    
    private let criteria: [Date]
    
    private let maxCost: CGFloat
    
    /// maxCost를 기준으로 0 ~ maxCost 사이의 값을 n등분하여 배열로 저장하는 프로퍼티. 0과 maxCost는 포함되지 않고 사잇값만 저장한다.
    private var costStandards: [CGFloat] {
        var array: [CGFloat] = []
        for order in 1 ..< Metric.dividerCount {
            array.append(maxCost / CGFloat(Metric.dividerCount) * CGFloat(order))
        }
        
        return array
    }
    
    private var dataRect: CGRect {
        return CGRect(
            x: rect.minX + inset.width,
            y: rect.minY + inset.height,
            width: rect.width - inset.width,
            height: rect.height - 2 * inset.height
        )
    }
    
    // MARK: - Init
    
    init(rect: CGRect, inset: CGSize, criteria: [Date], maxCost: CGFloat) {
        self.rect = rect
        self.inset = inset
        self.criteria = criteria
        self.maxCost = maxCost
        
        super.init()
        
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Functions
    
    private func configure() {
        configureBackgroundPath()
        configureAttributes()
        configureSubLayers()
    }
    
    /// 막대 차트의 배경 라인을 그린다.
    private func configureBackgroundPath() {
        let columnRowPath = UIBezierPath()
        
        columnRowPath.move(to: CGPoint(x: dataRect.maxX, y: dataRect.maxY))
        columnRowPath.addLine(to: CGPoint(x: dataRect.minX, y: dataRect.maxY))
        columnRowPath.addLine(to: CGPoint(x: dataRect.minX, y: dataRect.minY))
        
        UIColor.clear.set()
        
        path = columnRowPath.cgPath
    }
    
    /// 배경 라인의 속성값을 지정한다.
    private func configureAttributes() {
        lineWidth = Metric.lineWidth
        fillColor = UIColor.white?.cgColor
        strokeColor = UIColor.grey2?.cgColor
    }
    
    /// 배경에 날짜, 금액 단위를 텍스트로 표시한다.
    private func configureSubLayers() {
        for index in criteria.indices {
            configureDateTextLayer(with: index)
        }
        
        for index in costStandards.indices {
            configureCostTextLayer(with: index)
        }
    }
    
    /// 배경의 하단에 차트 데이터 값이 존재하는 날짜를 표시한다.
    private func configureDateTextLayer(with index: Int) {
        let textWidth = (rect.width - inset.width) / CGFloat(criteria.count)
        let textHeight = inset.height
        let baseX = rect.minX + inset.width
        
        let dateTextFrame = CGRect(
            x: baseX + textWidth * CGFloat(index),
            y: rect.maxY - textHeight,
            width: textWidth,
            height: textHeight
        )
        
        let dateTextLayer = BarTextLayer(
            rect: dateTextFrame,
            text: Date.yearMonthDaySplitDashDateFormatter.string(from: criteria[index])
        )
        addSublayer(dateTextLayer)
    }
    
    /// 배경의 좌측에 최고 금액을 기준으로 나눈 금액 단위를 표시한다.
    private func configureCostTextLayer(with index: Int) {
        let costWidth = inset.width
        let costHeight = (rect.height - inset.height) / CGFloat(costStandards.count + 1)
        let baseY = rect.maxY - inset.height
        
        let costTextFrame = CGRect(
            x: rect.minX,
            y: baseY - costHeight * CGFloat(index + 1),
            width: costWidth,
            height: costHeight
        )
        
        let costTextLayer = BarTextLayer(
            rect: costTextFrame,
            text: Int(costStandards[index]).numberFormatter(),
            textFontSize: 9
        )
        addSublayer(costTextLayer)
    }
}

// MARK: - Namespaces

extension BarBackgroundLayer {
    enum Metric {
        static let dividerCount = 5
        static let lineWidth: CGFloat = 2
        static let textFontSize: CGFloat = 14
    }
}
