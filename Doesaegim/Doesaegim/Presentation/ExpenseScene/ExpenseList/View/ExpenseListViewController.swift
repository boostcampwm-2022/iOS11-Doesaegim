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
    
    lazy var expenseCollectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 12
        return collectionView
    }()
    
    var travelID: UUID? // 여행목록에서 선택한 여행의 ID. 지출목록을 가져오는데에 사용한다.
    private var expenseDataSource: DataSource?
    private let viewModel: ExpenseListViewModelProtocol? = ExpenseListViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expenseCollectionView.delegate = self
        viewModel?.delegate = self
        
        configureView()
        configureNavigationBar()
        configureSubviews()
        configureConstraints()
        configureCollectionView()
        configureCollectionViewDataSource()
        
        viewModel?.fetchCurrentTravel(with: travelID)
//        viewModel?.addExpenseData()
        viewModel?.fetchExpenseData()
        
        // TODO: - 임시 데이터 추가코드 추후 삭제
        for _ in 0..<10 {
            
        }
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
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
    }
    
    // MARK: - Collection View
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            let sectionHeaderSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: sectionHeaderSize,
                elementKind: HeaderKind.sectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        
        let globalHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(350)
        )
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: globalHeaderSize,
            elementKind: HeaderKind.globalHeader,
            alignment: .top
        )
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = [globalHeader]
        layout.configuration = configuration
        
        return layout
    }
    
    private func createLayoutConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let globalHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(200)
        )
        
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: globalHeaderSize,
            elementKind: HeaderKind.globalHeader,
            alignment: .top
        )
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.boundarySupplementaryItems = [globalHeader]
        
        return configuration
        
    }
    
    private func configureCollectionViewDataSource() {
        
        var date: Date?
        let expenseCell = CellRegistration { cell, _, identifier in
            cell.configureContent(with: identifier)
            // TODO: - 페이지네이션
            date = identifier.date
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
        ) { [weak self] supplementaryView, _, _ in
            // 세번째 파라미터는 indexPath
            supplementaryView.configureData(with: self?.viewModel)
        }
        
        // TODO: - section Header 타이틀 바꾸기
        let sectionHeaderRegistration = SectionHeaderRegistration(
            elementKind: HeaderKind.sectionHeader
        ) { _, _, _ in
        }
        
        // TODO: - 추후 self에 접근한다면 [weak self] 작성
        expenseDataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            
            if kind == HeaderKind.globalHeader {
                let globalHeader = collectionView.dequeueConfiguredReusableSupplementary(
                    using: globalHeaderRegistration,
                    for: indexPath
                )
                return globalHeader
            }
            
            let sectionHeader = collectionView.dequeueConfiguredReusableSupplementary(
                using: sectionHeaderRegistration,
                for: indexPath
            )
            sectionHeader.configureData(date: date)
            return sectionHeader
        }
        
    }
    
    // MARK: - Action
    
    @objc func didAddExpenseButtonTap() {
        navigationController?.pushViewController(
            ExpenseAddViewController(travel: viewModel?.currentTravel),
            animated: true
        )
    }
}

// MARK: - ExpenseListViweModelDelegate

extension ExpenseListViewController: ExpenseListViewModelDelegate {
    
    func expenseListDidChanged() {
        
        guard let viewModel = viewModel else { return }
        
        let expenseInfos = viewModel.expenseInfos
        
        if expenseInfos.isEmpty {
            placeholdView.isHidden = false
        } else {
            placeholdView.isHidden = true
        }
        
        var snapshot = SnapShot()
        snapshot.appendSections(viewModel.sections)
        
        for info in expenseInfos {
            let formatter = Date.yearMonthDayDateFormatter
            let dateString = formatter.string(from: info.date)
            
            snapshot.appendItems([info], toSection: dateString)
        }
        
        expenseDataSource?.apply(snapshot)
    }
}

// MARK: - UICollectionViewDelegate

extension ExpenseListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
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
