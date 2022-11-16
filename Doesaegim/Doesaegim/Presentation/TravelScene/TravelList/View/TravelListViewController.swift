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
    private typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, TravelInfoViewModel>
    
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
        
        // TODO: - 임시 데이터 저장, 추후 삭제
        do {
//            for index in 1...100 {
//                try Travel.addAndSave(with: TravelDTO(name: "\(index)번째 여행!", startDate: Date(), endDate: Date()))
//            }
        } catch {
            print(error.localizedDescription)
        }
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
    
    private func configureCollectionViewDataSource() {
        let travelCell = CellRegistration { cell, indexPath, identifier in
//            cell.configureLabel(with: identifier)
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "airplane.departure")
            content.imageProperties.tintColor = .primaryOrange
            content.attributedText = NSAttributedString(
                string: identifier.title,
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 20),
                    .foregroundColor: UIColor.black!
                ]
            )
            content.secondaryAttributedText = NSAttributedString(
                string: Date.convertTravelString(
                    start: identifier.startDate,
                    end: identifier.endDate
                ),
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.grey4!
                ]
            )
            cell.contentConfiguration = content
                        
            if let viewModel = self.viewModel,
               indexPath.row == viewModel.travelInfos.count - 1 {
                DispatchQueue.main.async {
                    viewModel.fetchTravelInfo()
                }
            }
            
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
        // 여행 추가 뷰컨트롤러 이동
        navigationController?.pushViewController(TravelAddViewController(), animated: true)
    }
}

// MARK: - TravelListControllerDelegate

extension TravelListViewController: TravelListViewModelDelegate {
    func travelListSnapshotShouldChange() {
        // TODO: - ViewModel 작성 후 identifierItem 작성
        
        guard let viewModel = viewModel else {
            return
        }
        
        let travelInfos = viewModel.travelInfos
        var snapshot = SnapShot()
        
        snapshot.appendSections(["main section"])
        snapshot.appendItems(travelInfos)
        self.travelDataSource?.apply(snapshot, animatingDifferences: true)
        
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

// MARK: - UICollectionViewDelegate

extension TravelListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - 적당한 Plan으로 이동. 선택한 데이터의 UUID를 넘겨서 이동한 컨트롤러에서 데이터를 불러온다.
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
