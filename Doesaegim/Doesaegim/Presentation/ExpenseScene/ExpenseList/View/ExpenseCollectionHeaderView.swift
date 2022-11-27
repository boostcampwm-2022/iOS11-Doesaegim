//
//  ExpenseCollectionHeaderView.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/17.
//

import UIKit

final class ExpenseCollectionHeaderView: UICollectionReusableView {
    
    // MARK: - UI Properties
    
    /// 원형 차트 뷰
    private lazy var pieChart = CustomPieChart(items: data)
    
    /// 여행 제목 레이블
    private let travelTitleLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiteral.defaultTravelTitle
        label.font = label.font.withSize(FontSize.title)
        
        return label
    }()
    
    /// 지출 및 예산 레이블
    private let expenseBudgetLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiteral.defaultExpenseBudgetText
        label.font = label.font.withSize(FontSize.body)
        
        return label
    }()
    
    /// 전체 컨텐츠 스택 뷰
    private let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    /// 블러 처리 뷰
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return visualEffectView
    }()
    
    // MARK: - Properties
    
    /// 블러처리 여부
    private var isBlur: Bool = true {
        didSet {
            blurEffectView.isHidden = !isBlur
        }
    }
    
    /// 차트 데이터
    private var data: [CustomChartItem] = ExpenseCollectionHeaderView.dummyData {
        didSet {
            pieChart.setupData(with: data)
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
        
        configure()
    }
    
    // MARK: - Configure Functions
    
    private func configure() {
        configureSubviews()
        configureConstraints()
    }
    
    /// 차트 뷰, 여행 타이틀 레이블, 예산 레이블 등의 서브 뷰들을 추가한다.
    private func configureSubviews() {
        contentStack.addArrangedSubviews(pieChart, travelTitleLabel, expenseBudgetLabel)
        addSubviews(contentStack, blurEffectView)
    }
    
    /// 서브뷰의 오토레이아웃/프레임을 설정한다.
    private func configureConstraints() {
        contentStack.frame = bounds
    }
    
    // MARK: - Configure Functions With ViewModel
    
    /// 외부의 뷰모델 데이터를 받아와서 차트 데이터, 여행 제목, 총 지출 데이터를 지정해 화면에 표시한다.
    /// - Parameter data: 여행 제목, 지출 데이터가 포함된 뷰모델 프로토콜
    func configureData(with data: ExpenseListViewModelProtocol?) {
        guard let data else { return }
        
        let graphData: [CustomChartItem] = data.expenseInfos.compactMap({
            let value = CGFloat($0.cost)
            guard let category = ExpenseType(rawValue: $0.category) else { return nil }

            let item = CustomChartItem(category: category, value: value)
            return item
        })
        let totalExpenses = data.expenseInfos.reduce(0) { $0 + $1.cost }
        
        travelTitleLabel.text = data.currentTravel?.name
        
        expenseBudgetLabel.text = "총 지출액: \(totalExpenses.numberFormatter())원"
        
        if !graphData.isEmpty { self.data = graphData }
        isBlur = graphData.isEmpty
    }
}

// MARK: - Namespaces

extension ExpenseCollectionHeaderView {
    enum Metric {
        static let chartInsets: CGFloat = 46
    }
    
    enum StringLiteral {
        static let defaultTravelTitle = "되새김 여행"
        static let defaultExpenseBudgetText = "129,000 / 320,000"
    }
}

// MARK: - Chart dummy data

extension ExpenseCollectionHeaderView {
    static let dummyData = [
        CustomChartItem(category: .food, value: 70),
        CustomChartItem(category: .shopping, value: 30),
        CustomChartItem(category: .transportation, value: 50),
        CustomChartItem(category: .room, value: 60),
        CustomChartItem(category: .other, value: 20)
    ]
}
