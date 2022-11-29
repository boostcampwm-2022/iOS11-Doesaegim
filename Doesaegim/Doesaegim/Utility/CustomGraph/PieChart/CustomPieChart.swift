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
    
    private var isAnimating: Bool = false
    
    private var total: CGFloat {
        items.reduce(0) { $0 + $1.value }
    }
    
    // MARK: - Animation Properties
    
    private var startAngle: CGFloat = Metric.initialStartAngle
    
    private var currentIndex = 0
    
    private var currentItem: CustomChartItem { items[currentIndex] }
    
    private var ratio: CGFloat { currentItem.value / total }
    
    // MARK: - Init
    
    /// 원형 차트를 그릴 기반이 되는 데이터 값의 배열을 받아 차트 화면을 생성한다.
    /// - Parameters:
    ///   - data: 차트 데이터 값의 배열
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Draw Functions
    
    /// 주어진 rect에 맞게 원형 차트를 그린다. 원형 차트는 정원 형태로 영역에 꽉 채워서 그려진다.
    /// - Parameter rect: 원형 차트를 그릴 영역.
    override func draw(_ rect: CGRect) {
        if isAnimating {
            drawOnePiece(with: currentItem, on: rect)
            return
        }
        
        initializeAnimation()
        for index in items.indices {
            currentIndex = index
            drawOnePiece(with: currentItem, on: rect)
            startAngle += ratio * Metric.angle
        }

    }
    
    private func drawOnePiece(with item: CustomChartItem, on rect: CGRect) {
        let pieceLayer = PieceShapeLayer(
            rect: rect,
            startAngle: startAngle,
            angleRatio: ratio * Metric.angle,
            color: item.category.color.cgColor
        )
        layer.addSublayer(pieceLayer)
        
        guard let boundingBox = pieceLayer.path?.boundingBox else { return }
        let textLayer = PieceTextLayer(
            center: CGPoint(x: rect.width/2, y: rect.height/2),
            pieceBounds: boundingBox,
            text: "\(item.category.rawValue)\n\(String(format: "%.2f", ratio * 100))%"
        )
        layer.addSublayer(textLayer)
        
        if isAnimating {
            let pieceAnimation = configureLayerAnimation()
            pieceLayer.add(pieceAnimation, forKey: pieceAnimation.keyPath)
        }
    }
    
    // MARK: - Configure Functions
    
    /// 차트 뷰의 배경색 지정
    private func configureBackgroundColor() {
        backgroundColor = .white
    }
    
    /// 파이 조각별 애니메이션 설정
    private func configureLayerAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: StringLiteral.animationKey)
        animation.fromValue = Metric.animationFromValue
        animation.toValue = Metric.animationToValue
        animation.duration = ratio * Metric.animationDuration
        animation.delegate = self
        
        return animation
    }
    
    // MARK: - Setup Data & Redraw Functions
    
    /// 차트를 표시하는 데이터를 변경할 경우 실행하는 메서드. 데이터를 설정하고 차트를 다시 그린다.
    /// - Parameter data: 변경할 차트 데이터
    func setupData(with data: [CustomChartItem]) {
        self.items = data
        self.isAnimating = !data.isEmpty
        initializeAnimation()
        
        setNeedsDisplay()
    }
    
    private func initializeAnimation() {
        startAngle = Metric.initialStartAngle
        currentIndex = 0
    }
    
}

// MARK: - CAAnimationDelegate

extension CustomPieChart: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag, currentIndex < items.count - 1 else { return }
        
        startAngle += ratio * Metric.angle
        currentIndex += 1
        setNeedsDisplay()
    }
}

// MARK: - Namespaces

extension CustomPieChart {
    enum Metric {
        static let initialStartAngle: CGFloat = (.pi) * 3 / 2
        static let angle: CGFloat = .pi * 2
        
        static let animationFromValue: CGFloat = 0
        static let animationToValue: CGFloat = 1
        static let animationDuration: CGFloat = 1.2
    }
    
    enum StringLiteral {
        static let animationKey = "strokeEnd"
    }
}
