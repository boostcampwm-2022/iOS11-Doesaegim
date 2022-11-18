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
    private typealias GlobalHeaderRegistration
        = UICollectionView.SupplementaryRegistration<ExpenseCollectionHeaderView>
    private typealias SectionHeaderRegistration
        = UICollectionView.SupplementaryRegistration<ExpenseSectionHeaderView>
    
    // MARK: - Properties
    
    let placeholdView: ExpensePlaceholdView = ExpensePlaceholdView()
    
    private var expenseDataSource: DataSource?
    
    lazy var expenseCollectionView: UICollectionView = {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        layout.configuration = createLayoutConfiguration()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
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
        configureCollectionView()
        configureCollectionViewDataSource()
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
    
    private func createLayoutConfiguration() ->  UICollectionViewCompositionalLayoutConfiguration {
        let globalHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100)
        )
        let sectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: globalHeaderSize,
            elementKind: HeaderKind.globalHeader,
            alignment: .top
        )
        globalHeader.pinToVisibleBounds = true
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: HeaderKind.sectionHeader,
            alignment: .top
        )
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        configuration.boundarySupplementaryItems = [globalHeader, sectionHeader]
        
        return configuration
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
        
        let globalHeaderRegistration = GlobalHeaderRegistration(
            elementKind: HeaderKind.globalHeader
        ) { supplementaryView, _, _ in
            // 세번째 파라미터는 indexPath
            supplementaryView.configureData()
        }
        
        let sectionHeaderRgistration = SectionHeaderRegistration(
            elementKind: HeaderKind.sectionHeader
        ) { supplementaryView, _, _ in
            supplementaryView.configureData(dateString: "날짜입니다.")
        }
        
        expenseDataSource?.supplementaryViewProvider = { [weak self] (_, kind, indexPath) in
            if kind == HeaderKind.globalHeader {
                return self?.expenseCollectionView.dequeueConfiguredReusableSupplementary(
                    using: globalHeaderRegistration,
                    for: indexPath
                )
            }
            
            return self?.expenseCollectionView.dequeueConfiguredReusableSupplementary(
                using: sectionHeaderRgistration,
                for: indexPath
            )
        }
        
    }
    
    // MARK: - Action
    
    @objc func didAddExpenseButtonTap() {
        // TODO: - 지출 추가 화면으로 이동
        print("지출 추가버튼이 탭 되었습니다.")
    }
}

// MARK: - Constant
fileprivate extension ExpenseListViewController {
    enum StringLiteral {
        static let sectionHeaderElementKind = "UICollectionElementKindSectionHeader"
    }
    
    enum HeaderKind {
        static let globalHeader = "CollectionViewGlobalHeader"
        static let sectionHeader = "CollectionViewSectionHeader"
    }
}
