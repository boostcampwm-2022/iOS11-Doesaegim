//
//  ExpenseCollectionHeaderView.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/17.
//

import UIKit

final class ExpenseCollectionHeaderView: UICollectionReusableView {
    
    // MARK: - UI Properties
    
    private var graphView = ExpenseGraphView() {
        didSet {
            configure()
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Configure Functions
    
    private func configure() {
        configureSubviews()
        configureFrame()
    }
    
    func configureData(with data: [ExpenseInfoViewModel]?) {
        guard let data else { return }
        
        let graphData: [CustomChartItem] = data.map {
            let value = CGFloat($0.cost)
            let category = ExpenseType(rawValue: $0.content)!
            
            let item = CustomChartItem(category: category, value: value)
            return item
        }
        
        graphView = ExpenseGraphView(data: graphData)
    }
    
    private func configureSubviews() {
        addSubview(graphView)
    }
    
    private func configureFrame() {
        graphView.frame = bounds
    }
}
