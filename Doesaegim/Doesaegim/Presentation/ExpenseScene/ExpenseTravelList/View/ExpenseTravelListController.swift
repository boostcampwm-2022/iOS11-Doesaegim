//
//  ExpenseViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit

import SnapKit

final class ExpenseTravelListController: UIViewController {

    private typealias DataSource
        = UICollectionViewDiffableDataSource<String, TravelExpenseInfoViewModel>
    private typealias SnapShot
        = NSDiffableDataSourceSnapshot<String, TravelExpenseInfoViewModel>
    private typealias CellRegistration
        = UICollectionView.CellRegistration<ExpenseTravelCollectionViewCell, TravelExpenseInfoViewModel>
    
    // MARK: - Properties
    
    let placeholdLabel: UILabel = {
        let label = UILabel()
        label.text = "일정 탭에서 새로운 여행을 추가해주세요!"
        label.textColor = .grey2
        
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = createCollectionViewListLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 12
        
        return collectionView
    }()
    
    private var travelDataSource: DataSource?
    
    var selectedID: UUID?
    
    private var viewModel: ExpenseTravelViewModelProtocol? = ExpenseTravelViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewModel?.delegate = self
        collectionView.delegate = self
        
        configureNavigationBar()
        configureSubviews()
        configureConstratins()
        configureCollectionViewDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        viewModel?.fetchTravelInfo()
        
    }

    // MARK: - Configure
    
    func configureNavigationBar() {
        navigationItem.title = "여행 목록"
    }
    
    func configureSubviews() {
        view.addSubview(collectionView)
        view.addSubview(placeholdLabel)
    }
    
    func configureConstratins() {
        placeholdLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        collectionView.snp.makeConstraints {
            
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
        }
    }
    
    // MARK: - Collection View
    
    private func createCollectionViewListLayout() -> UICollectionViewLayout {
        
        let heightDimension = NSCollectionLayoutDimension.estimated(70)
        
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: heightDimension
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: .fixed(0),
                top: .fixed(4),
                trailing: .fixed(0),
                bottom: .fixed(4)
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: heightDimension
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        return layout
        
        
        
    }
    
    private func configureCollectionViewDataSource() {
        let travelCell =  CellRegistration { cell, indexPath, identifier in
            guard let viewModel = self.viewModel else { return }
            cell.configure(with: identifier)
        }
        
        travelDataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: travelCell,
                    for: indexPath,
                    item: item
                )
            }
        )   
    }
}

// MARK: - UICollectionViewDelegate

extension ExpenseTravelListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        let expenseListViewController = ExpenseListViewController()
        selectedID = viewModel.expenseInfos[indexPath.row].travel.uuid
        expenseListViewController.travelID = selectedID
        navigationController?.pushViewController(expenseListViewController, animated: true)
    }
}


// MARK: - ExpenseTravelViewModelDelegate

extension ExpenseTravelListController: ExpenseTravelViewModelDelegate {
    
    func travelListSnapshotShouldChange() {

        guard let viewModel = viewModel else { return }
        
        let expenseInfos = viewModel.expenseInfos
        var snapshot = SnapShot()
        snapshot.appendSections(["main section"])
        snapshot.appendItems(expenseInfos, toSection: "main section")
        
        travelDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func travelPlaceholderShouldChange() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        let expenseInfos = viewModel.expenseInfos
        placeholdLabel.isHidden = !expenseInfos.isEmpty
    }
    
    func travelListFetchDidFail() {
        let alert = UIAlertController(
            title: "불러오기 실패",
            message: "여행정보 불러오기를 실패하였습니다",
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}


