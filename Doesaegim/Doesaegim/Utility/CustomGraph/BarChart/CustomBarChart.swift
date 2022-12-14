//
//  CustomBarChart.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/30.
//

import UIKit

/// Custom Bar Chart
final class CustomBarChart: UIView {

    // MARK: - Properties

    private var items: [CustomChartItem<Date>] = []
    
    private var isAnimating: Bool = false

    private var max: CGFloat {
        return items.max(by: { $0.value < $1.value })?.value ?? 0
    }
    
    // MARK: - Animation Properties
    
    

    // MARK: - Init

    /// 막대 차트를 그릴 기반이 되는 데이터 값의 배열을 받아 차트 화면을 생성한다.
    /// - Parameters:
    ///   - data: 차트 데이터 값의 배열
    convenience init(
        items: [CustomChartItem<Date>],
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

    // MARK: - Configure Functions

    private func configureBackgroundColor() {
        backgroundColor = .white
    }

    // MARK: - Draw Functions

    /// 주어진 rect에 맞게 막대 차트를 그린다. 막대 차트는 영역에 꽉 채워서 그려진다.
    /// - Parameter rect: 막대 차트를 그릴 영역.
    override func draw(_ rect: CGRect) {
        // 기존에 추가한 서브레이어를 모두 지운다.
        removeAllSubLayers()
        
        // 차트 배경 그리기
        let criteria = items.map { $0.criterion }
        let backgroundLayer = BarBackgroundLayer(
            rect: rect,
            inset: Metric.chartInset,
            criteria: criteria,
            maxCost: max
        )
        layer.addSublayer(backgroundLayer)
        
        // 차트 데이터 그리기
        let dataRect = CGRect(
            x: rect.minX + Metric.chartInset.width,
            y: rect.minY + Metric.chartInset.height,
            width: rect.width - Metric.chartInset.width,
            height: rect.height - 2 * Metric.chartInset.height
        )
        for idx in items.indices {
            drawOneBar(at: idx, on: dataRect)
        }
    }
    
    /// 막대 차트 중 하나의 막대를 그려 서브레이어로 추가한다.
    /// - Parameters:
    ///   - index: 그릴 막대의 순서
    ///   - rect: 막대를 그릴 영역
    private func drawOneBar(at index: Int, on rect: CGRect) {
        let value = items[index].value
        let barWidth = rect.width / CGFloat(items.count)
        let barLayerFrame = CGRect(
            x: rect.minX + barWidth * CGFloat(index),
            y: rect.minY,
            width: barWidth,
            height: rect.height
        )
        let barLayer = BarShapeLayer(
            rect: barLayerFrame,
            color: UIColor.primaryOrange?.cgColor ?? UIColor().cgColor,
            value: value * (rect.height / max)
        )

        layer.addSublayer(barLayer)
        
        if isAnimating { barLayer.addAnimation() }
    }
    
    // MARK: - Setup Data & Redraw Functions

    /// 차트를 표시하는 데이터를 변경할 경우 실행하는 메서드. 데이터를 설정하고 차트를 다시 그린다.
    /// - Parameter data: 변경할 차트 데이터
    func setupData(with data: [CustomChartItem<Date>]) {
        self.items = data
        self.isAnimating = !data.isEmpty

        executeAnimation()
    }
    
    // MARK: - Animation Functions
    
    /// 외부의 값 변화로 인해 애니메이션을 재실행할 경우 활용할 수 있는 메서드. 화면을 다시 그린다.
    func executeAnimation() {
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

extension CustomBarChart {
    enum Metric {
        static let chartInset = CGSize(width: 50, height: 30)
    }
}
