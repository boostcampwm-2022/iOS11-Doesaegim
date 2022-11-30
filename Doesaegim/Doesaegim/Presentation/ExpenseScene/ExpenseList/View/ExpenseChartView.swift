//
//  ExpenseChartView.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/30.
//

import UIKit

final class ExpenseChartView: UIView {

    // MARK: - UI Properties
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["카테고리별", "날짜별"])
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    /// 원형 차트 뷰
    private lazy var pieChart = CustomPieChart(items: pieChartData)
    
    /// 막대 차트 뷰
    private lazy var barChart = CustomBarChart(items: barChartData)
    
    /// 원형 차트 또는 막대 차트가 표시되는 뷰
    private let chartView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// 모든 컨텐츠가 포함되는 스택 뷰
    private let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    
    
    // MARK: - Properties
    
    /// 원형 차트 데이터
    private var pieChartData: [CustomChartItem<ExpenseType>] = ExpenseChartView.pieChartDummies {
        didSet {
            pieChart.setupData(with: pieChartData)
        }
    }
    
    /// 막대 차트 데이터
    private var barChartData: [CustomChartItem<Date>] = ExpenseChartView.barChartDummies {
        didSet {
            barChart.setupData(with: barChartData)
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
        configureConstraint()
        configureInitialChartView()
        configureSegmentedControl()
    }
    
    private func configureSubviews() {
        chartView.addSubviews(pieChart, barChart)
        contentStack.addArrangedSubviews(segmentedControl, chartView)
        
        addSubview(contentStack)
    }
    
    private func configureConstraint() {
        pieChart.snp.makeConstraints { $0.edges.equalToSuperview() }
        barChart.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    /// 초기에 화면 진입 시 어떤 차트를 보여줄 것인지 지정한다.
    private func configureInitialChartView() {
        pieChart.isHidden = false
        barChart.isHidden = true
    }
    
    /// 세그먼티드 컨트롤에 액션을 추가한다.
    private func configureSegmentedControl() {
        segmentedControl.addTarget(
            self,
            action: #selector(segmentedControlValueDidChange),
            for: .valueChanged
        )
    }
    
    // MARK: - objc Functions
    
    /// 세그먼티드 컨트롤의 값이 변경되었을 때 보여줄 차트를 지정한다.
    @objc func segmentedControlValueDidChange() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        pieChart.isHidden = selectedIndex == 0 ? false : true
        barChart.isHidden = !pieChart.isHidden
        
        if !pieChart.isHidden {
            pieChart.executeAnimation()
        } else {
            barChart.executeAnimation()
        }
    }
    
    // MARK: - Setup Functions
    
    /// 지출 데이터를 전달 받아 원형 그래프와 막대 그래프용 데이터로 변형 및 지정한다.
    /// - Parameter data: 지출 데이터
    /// - Returns: 지출데이터의 존재여부
    func setupData(with data: ExpenseListViewModelProtocol) {
        setupPieChartData(with: data)
        setupBarChartData(with: data)
    }
    
    /// 원형 차트의 데이터를 설정한다.
    /// - Parameter data: 원본 지출 데이터
    private func setupPieChartData(with data: ExpenseListViewModelProtocol) {
        var chartData: [CustomChartItem] = ExpenseType.allCases.map {
            CustomChartItem(criterion: $0, value: 0)
        } // 사용자가 지출정보를 추가하는 순서대로 조각이 표시되는 게 아닌, 카테고리 자체 순서대로 조각이 추가되도록
        
        data.expenseInfos.forEach { item in
            guard let type = ExpenseType(rawValue: item.category) else { return }
            let graphValue = CGFloat(item.cost)
            
            if let foundIndex = chartData.firstIndex(where: { $0.criterion == type }) {
                chartData[foundIndex].value += graphValue
            }
        }
        chartData = chartData.filter { $0.value != 0 }
        
        if !chartData.isEmpty { self.pieChartData = chartData }
    }
    
    /// 막대 차트의 데이터를 설정한다.
    /// - Parameter data: 원본 지출 데이터
    private func setupBarChartData(with data: ExpenseListViewModelProtocol) {
        let expenseData = data.expenseInfos.sorted { $0.date < $1.date }
        var chartData: [CustomChartItem<Date>] = []
        
        expenseData.forEach { item in
            let graphValue = CGFloat(item.cost)
            
            if let foundIndex = chartData.firstIndex(where: {$0.criterion == item.date }) {
                chartData[foundIndex].value += graphValue
            } else {
                chartData.append(CustomChartItem(criterion: item.date, value: graphValue))
            }
        }
        chartData.sort { $0.criterion < $1.criterion }
        
        if !chartData.isEmpty { self.barChartData = chartData }
    }

}

extension ExpenseChartView {
    static let pieChartDummies: [CustomChartItem<ExpenseType>] = [
        CustomChartItem(criterion: .food, value: 70),
        CustomChartItem(criterion: .shopping, value: 30),
        CustomChartItem(criterion: .transportation, value: 50),
        CustomChartItem(criterion: .room, value: 60),
        CustomChartItem(criterion: .other, value: 20)
    ]
    
    static let barChartDummies: [CustomChartItem<Date>] = [
        CustomChartItem(
            criterion: Date.yearMonthDateFormatter.date(from: "2022-11-30") ?? Date(),
            value: 70
        ),
        CustomChartItem(
            criterion: Date.yearMonthDateFormatter.date(from: "2022-11-30") ?? Date(),
            value: 30
        ),
        CustomChartItem(
            criterion: Date.yearMonthDateFormatter.date(from: "2022-11-30") ?? Date(),
            value: 50
        ),
        CustomChartItem(
            criterion: Date.yearMonthDateFormatter.date(from: "2022-11-30") ?? Date(),
            value: 60
        ),
        CustomChartItem(
            criterion: Date.yearMonthDateFormatter.date(from: "2022-11-30") ?? Date(),
            value: 20
        )
    ]
}
