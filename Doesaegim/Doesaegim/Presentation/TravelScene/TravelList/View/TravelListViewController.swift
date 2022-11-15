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
        return collectionView
        
    }()
    
    private var travelDataSource: UICollectionViewDiffableDataSource<String, TravelInfoViewModel>?
    
    private var viewModel: TravelListControllerProtocol? = TravelListViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel?.delegate = self
        // Do any additional setup after loading the view.
        configureSubviews()
        configureConstraints()
        configureNavigationBar()
        configureCollectionViewDataSource()
        configureTravelData()
        
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
    
    private func configureTravelData() {
        
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) ->
            NSCollectionLayoutSection  in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 6)
            
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        return layout
    }
    
    private func configureCollectionViewDataSource() {
        let travelCell = UICollectionView.CellRegistration<TravelCollectionViewCell, TravelInfoViewModel> {
            (cell, indexPath, identifier) in
            cell.configureLabel(with: identifier)
        }
        
        travelDataSource = UICollectionViewDiffableDataSource<String, TravelInfoViewModel>(
            collectionView: planCollectionView, cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: travelCell,
                    for: indexPath,
                    item: item)
            })
    }
    
    // TODO: - 주석 해제 추후 결정
//    private func applySnapshot() {
//
//
//    }
    
    // MARK: - Actions
    
    @objc func didAddTravelButtonTap() {
        print("여행 추가 버튼이 탭 되었습니다.")
        // TODO - 임시로 여행목록 패치. 추후 제거
        viewModel?.fetchTravelInfo()
        print(viewModel?.travelInfos)
    }
}

extension TravelListViewController: TravelListControllerDelegate {
    func applyTravelSnapshot() {
        // TODO: - ViewModel 작성 후 identifierItem 작성
        
        guard let viewModel = viewModel else {
            return
        }
        
        let travelInfos = viewModel.travelInfos
        var snapshot = NSDiffableDataSourceSnapshot<String, TravelInfoViewModel>()
        
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
