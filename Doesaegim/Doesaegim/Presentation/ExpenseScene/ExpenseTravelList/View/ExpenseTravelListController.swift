//
//  ExpenseViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit

import SnapKit

final class ExpenseTravelListController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<String, TravelInfoViewModel>
    typealias SnapShot = NSDiffableDataSourceSnapshot<String, TravelInfoViewModel>
    typealias CellRegistration = UICollectionView.CellRegistration<ExpenseTravelListCell, TravelInfoViewModel>
    
    // MARK: - Properties
    
    let placeholdLabel: UILabel = {
        let label = UILabel()
        label.text = "일정 탭에서 새로운 여행을 추가해주세요!"
        label.textColor = .grey2
        
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = collectionViewListLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 7
        
        return collectionView
    }()
    
    var travelDataSource: DataSource?
    
    var selectedID: UUID?
    
    var viewModel: ExpenseTravelViewModelProtocol? = ExpenseTravelViewModel()
    
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
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(0)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        
        switch destinationViewController {
        case let viewController as ExpenseListViewController:
            print("ExpenseListViewcontroller로 이동합니다.")
            viewController.travelID = selectedID
        default:
            print("잘못된 접근입니다.")
        }
    }
    
    // MARK: - Collection View
    
    private func collectionViewListLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .white
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func configureCollectionViewDataSource() {
        let travelCell =  CellRegistration { cell, indexPath, identifier in
            
            cell.configureContent(with: identifier)
            
            // TODO: - 페이지 네이션 기준도 상수로 만들어서 사용하면 좋겠다.
            // pagination
            if let viewModel = self.viewModel,
               indexPath.row == viewModel.travelInfos.count - 3 {
                DispatchQueue.main.async {
                    viewModel.fetchTravelInfo()
                }
            }
            
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
        
        selectedID = viewModel.travelInfos[indexPath.row].uuid
        navigationController?.pushViewController(ExpenseListViewController(), animated: true)
    }
}


// MARK: - ExpenseTravelViewModelDelegate

extension ExpenseTravelListController: ExpenseTravelViewModelDelegate {
    
    func travelListSnapshotShouldChange() {

        guard let viewModel = viewModel else {
            return
        }
        
        let travelInfos = viewModel.travelInfos
        var snapshot = SnapShot()
        
        snapshot.appendSections(["main section"])
        snapshot.appendItems(travelInfos)
        travelDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func travelPlaceholderShouldChange() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        let travelInfos = viewModel.travelInfos
        if travelInfos.isEmpty {
            placeholdLabel.isHidden = false
        } else {
            placeholdLabel.isHidden = true
        }
    }
}
