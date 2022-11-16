//
//  TravelPlanViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit

import SnapKit

// TODO: - 클래스 이름 TravelListViewController로 바꾸면 좋을듯함...

final class TravelListViewController: UIViewController {

    private typealias DataSource = UICollectionViewDiffableDataSource<String, TravelInfoViewModel>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<String, TravelInfoViewModel>
    private typealias CellRegistration = UICollectionView.CellRegistration<TravelCollectionViewCell, TravelInfoViewModel>
    
    // MARK: - Properties
    
    private let placeholdLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 여행을 떠나볼까요?"
        label.textColor = .grey2
        
        return label
    }()
    
    private lazy var planCollectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 7
        return collectionView
        
    }()
    
    private var travelDataSource: DataSource?
    
    private var viewModel: TravelListControllerProtocol? = TravelListViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewModel?.delegate = self
        
        configureSubviews()
        configureConstraints()
        configureNavigationBar()
        configureCollectionViewDataSource()
        
        // TODO: - 임시 데이터 저장, 추후 삭제
        do {
//            try Travel.addAndSave(with: TravelDTO(name: "일본여행", startDate: Date(), endDate: Date()))
//            try Travel.addAndSave(with: TravelDTO(name: "프랑스여행", startDate: Date(), endDate: Date()))
//            try Travel.addAndSave(with: TravelDTO(name: "필리핀여행", startDate: Date(), endDate: Date()))
//            try Travel.addAndSave(with: TravelDTO(name: "하와이여행", startDate: Date(), endDate: Date()))
        } catch {
            print(error.localizedDescription)
        }
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
    
    private func configureCollectionView() {
        
        // 셀 등록
        planCollectionView.register(
            TravelCollectionViewCell.self,
            forCellWithReuseIdentifier: TravelCollectionViewCell.identifier
        )
    }
    
    private func configureCollectionViewDataSource() {
        let travelCell = CellRegistration { cell, _, identifier in
            cell.configureLabel(with: identifier)
        }
        
        travelDataSource = DataSource(
            collectionView: planCollectionView, cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: travelCell,
                    for: indexPath,
                    item: item)
            })
    }
    
    // MARK: - Actions
    
    @objc func didAddTravelButtonTap() {
        print("여행 추가 버튼이 탭 되었습니다.")
        // TODO - 임시로 여행목록 패치. 추후 제거
        viewModel?.fetchTravelInfo()
        print(viewModel?.travelInfos ?? [])
    }
}

// MARK: - TravelListControllerDelegate

extension TravelListViewController: TravelListControllerDelegate {
    func applyTravelSnapshot() {
        // TODO: - ViewModel 작성 후 identifierItem 작성
        
        guard let viewModel = viewModel else {
            return
        }
        
        let travelInfos = viewModel.travelInfos
        var snapshot = SnapShot()
        
        snapshot.appendSections(["main section"])
        snapshot.appendItems(travelInfos)
        travelDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func applyPlaceholdLabel() {
        
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

extension TravelListViewController {
    
    private func deleteTravel(with travelInfo: TravelInfoViewModel) {
        let uuid = travelInfo.uuid
        viewModel?.deleteTravel(with: uuid)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath,
              let id = travelDataSource?.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteActionTitle = NSLocalizedString("삭제", comment: "여행 목록 삭제")
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: deleteActionTitle
        ) { [weak self] _, _, completion in
            self?.deleteTravel(with: id)
            // 원래는 스냅샷 업데이트 메서드를 호출해주지만 뷰모델에서 Travel배열의 변화를 감지하면 자동으로 호출하므로 불필요
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
