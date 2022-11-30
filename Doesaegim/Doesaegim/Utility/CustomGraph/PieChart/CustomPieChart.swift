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
        guard let category = item.category else { return }
        let pieceLayer = PieceShapeLayer(
            rect: rect,
            startAngle: startAngle,
            angleRatio: ratio * Metric.angle,
            color: category.color.cgColor
        )
        layer.addSublayer(pieceLayer)
        
        guard let boundingBox = pieceLayer.path?.boundingBox else { return }
        let textLayer = PieceTextLayer(
            center: CGPoint(x: rect.width/2, y: rect.height/2),
            pieceBounds: boundingBox,
            text: "\(category.rawValue)\n\(String(format: "%.2f", ratio * 100))%"
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
    
    // MARK: - Setup Data & Redraw Functions
    
    /// 차트를 표시하는 데이터를 변경할 경우 실행하는 메서드. 데이터를 설정하고 차트를 다시 그린다.
    /// - Parameter data: 변경할 차트 데이터
    func setupData(with data: [CustomChartItem]) {
        self.items = data
        self.isAnimating = !data.isEmpty
        initializeAnimation()
        
        setNeedsDisplay()
    }
    
    // MARK: - Animation Functions
    
    private func initializeAnimation() {
        startAngle = Metric.initialStartAngle
        currentIndex = 0
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
    
    /// 외부의 값 변화로 인해 애니메이션을 재실행할 경우 활용할 수 있는 메서드.
    /// 이전에 등록된 서브레이어들을 모두 제거하고, 애니메이션 설정 값들을 초기화 한 후 `draw(_:)`메서드를 재실행한다.
    func executeAnimation() {
        removeAllSubLayers()
        initializeAnimation()
        setNeedsDisplay()
    }
    
    // MARK: - Layer Functions
    
    /// 레이어에 등록되어 있던 모든 서브 레이어들을 제거한다.
    private func removeAllSubLayers() {
        layer.sublayers?.forEach({ layer in
            layer.removeFromSuperlayer()
        })
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
