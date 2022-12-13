//
//  TravelPlanViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit


import SnapKit

final class TravelListViewController: UIViewController {

    private typealias DataSource
    = UICollectionViewDiffableDataSource<String, TravelInfoViewModel>
    private typealias SnapShot
    = NSDiffableDataSourceSnapshot<String, TravelInfoViewModel>
    private typealias CellRegistration
    = UICollectionView.CellRegistration<TravelCollectionViewCell, TravelInfoViewModel>
    
    // MARK: - Properties
    
    private let placeholdLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 여행을 떠나볼까요?"
        label.textColor = .grey2
        
        return label
    }()
    
    private lazy var planCollectionView: UICollectionView = {
        
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 12
        return collectionView
        
    }()
    
    private var travelDataSource: DataSource?
    
    private var viewModel: TravelListViewModelProtocol? = TravelListViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        planCollectionView.delegate = self
        viewModel?.delegate = self
        
        configureSubviews()
        configureConstraints()
        configureNavigationBar()
        configureCollectionViewDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchTravelInfo()
    }
    
    // MARK: - Configure
    
    func configureSubviews() {
        view.addSubview(planCollectionView)
        view.addSubview(placeholdLabel)
    }
    
    func configureConstraints() {
        
        placeholdLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        planCollectionView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
        }
        
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.tintColor = .primaryOrange
        navigationItem.title = "여행 목록"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didAddTravelButtonTap)
        )
    }
    
    // MARK: - Configure CollectionView
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
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
        
        let travelCell = CellRegistration { cell, indexPath, identifier in
            cell.configure(with: identifier)
            cell.deleteAction = { [weak self] in
                let cancelAction = UIAlertAction(title: "취소", style: .default)
                let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self?.viewModel?.deleteTravel(with: identifier.uuid)
                }
                
                self?.presentAlert(
                    title: "여행을 삭제하시겠습니까?",
                    message: "관련된 일정, 지출, 다이어리가 전부 삭제됩니다. 정말 삭제하시겠습니까?",
                    actions: cancelAction, deleteAction
                )
            }
            
            
            if let viewModel = self.viewModel,
               viewModel.travelInfos.count >= 10,
               indexPath.row == viewModel.travelInfos.count - 1 {
                DispatchQueue.main.async {
                    viewModel.fetchTravelInfo()
                }
            }
        }
        
        travelDataSource = DataSource(
            collectionView: planCollectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: travelCell,
                    for: indexPath,
                    item: item)
            })
    }
    
    // MARK: - Actions
    
    @objc func didAddTravelButtonTap() {
        // 여행 추가 뷰컨트롤러 이동
        navigationController?.pushViewController(TravelWriteViewController(mode: .post), animated: true)
    }
}

// MARK: - TravelListControllerDelegate

extension TravelListViewController: TravelListViewModelDelegate {
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
    
    func travelListDeleteDataDidFail() {
        
        let okAction = UIAlertAction(title: "확인", style: .default)
        presentAlert(title: "삭제 실패", message: "여행정보 삭제하기를 실패하였습니다.", actions: okAction)
    }
    
    func travelListFetchDidFail() {
        
        let alertAction = UIAlertAction(title: "확인", style: .default)
        presentAlert(title: "로드 실패", message: "여행정보 불러오기를 실패하였습니다", actions: alertAction)
    }
}

// MARK: - UICollectionViewDelegate

extension TravelListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let travelViewModel = travelDataSource?.itemIdentifier(for: indexPath)
        else {
            return
        }
        let result = PersistentManager.shared.fetch(request: Travel.fetchRequest())
        switch result {
        case .success(let response):
            guard let travel = response.first(where: { $0.id == travelViewModel.uuid }) else {
                return
            }
            let planListViewModel = PlanListViewModel(
                travel: travel,
                repository: PlanLocalRepository()
            )
            let planListViewController = PlanListViewController(viewModel: planListViewModel)
            planListViewModel.delegate = planListViewController
            show(planListViewController, sender: nil)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
