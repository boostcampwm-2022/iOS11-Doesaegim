//
//  ExpenseListViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/17.
//

import UIKit

final class ExpenseListViewController: UIViewController {

    private typealias DataSource = UICollectionViewDiffableDataSource<String, ExpenseInfoViewModel>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<String, ExpenseInfoViewModel>
    private typealias CellRegistration
        = UICollectionView.CellRegistration<ExpenseListCell, ExpenseInfoViewModel>
//    private typealias HeaderRegistration
//    = UICollectionView.SupplementaryRegistration<
    
    
    // MARK: - Properties
    
    let placeholdView: ExpensePlaceholdView = ExpensePlaceholdView()
    
    private var expenseDataSource: DataSource?
    
    let expenseCollectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = true
//        configuration.trailingSwipeActionsConfigurationProvider
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // TODO: - cornerRadius 적용되지 않는 것 고민
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 12
        return collectionView
    }()
    
    var travelID: UUID? // 여행목록에서 선택한 여행의 ID. 지출목록을 가져오는데에 사용한다.
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSubviews()
        configureConstraints()
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        // TODO: - 여행 이름도 네비게이션 타이틀에 포함하기 "(여행이름) - 지출내역"
        navigationItem.title = "지출 내역"
        navigationController?.navigationBar.tintColor = .primaryOrange
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didAddExpenseButtonTap)
        )
    }
    
    private func configureSubviews() {
        view.addSubview(expenseCollectionView)
        view.addSubview(placeholdView)
    }
    
    private func configureConstraints() {
        expenseCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        placeholdView.snp.makeConstraints {
            // TODO: - 뷰의 위치 추후 다시 설정
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY).multipliedBy(1.3)
            $0.width.equalTo(view.bounds.width - 100)
            $0.height.equalTo(50)
        }
        
        
    }
    
    private func configureCollectionView() {
        
        // 셀 등록
        expenseCollectionView.register(
            ExpenseListCell.self,
            forCellWithReuseIdentifier: ExpenseListCell.identifier
        )
        
        // 섹션 헤더 등록
        expenseCollectionView.register(
            ExpenseSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ExpenseSectionHeaderView.identifier
        )
        
        
    }
    
    // MARK: - Collection View
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = true
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    private func configureCollectionViewDataSource() {
        let expenseCell = CellRegistration { cell, indexPath, restorationIdentifier in
            cell.configureContent()
            
            // TODO: - 페이지네이션
        }
        
        expenseDataSource = DataSource(
            collectionView: expenseCollectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: expenseCell,
                    for: indexPath,
                    item: item
                )
            }
        )
        
        expenseDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ExpenseSectionHeaderView.identifier,
                for: indexPath
            )
            let section = self.expenseDataSource?.snapshot().sectionIdentifiers[indexPath.section]
            return view
        }
    }
    
    
    // MARK: - Action
    
    @objc func didAddExpenseButtonTap() {
        // TODO: - 지출 추가 화면으로 이동
        print("지출 추가버튼이 탭 되었습니다.")
    }
}
