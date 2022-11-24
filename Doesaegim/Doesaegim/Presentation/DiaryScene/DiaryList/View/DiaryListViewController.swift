//
//  DiaryListViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/24.
//

import UIKit


import SnapKit

final class DiaryListViewController: UIViewController {
    
    typealias DataSource
        = UICollectionViewDiffableDataSource<UUID, DiaryInfoViewModel>
    typealias CellRegistration
        = UICollectionView.CellRegistration<DiaryListCell, DiaryInfoViewModel>
    typealias SnapShot
        = NSDiffableDataSourceSnapshot<UUID, DiaryInfoViewModel>
    // TODO: - 헤더 등록타입
    
    // MARK: - Properties
    
    // TODO: - 나중에 생성자로 주입
    private let viewModel: DiaryListViewModelProtocol? = DiaryListViewModel()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 12
        return collectionView
        
    }()
    
    private let placeholdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey3
        label.text = "다이어리를 추가해주세요"
        
        return label
    }()
    
    private var diaryDataSource: DataSource?
    
    // MARK: - Initializer(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel?.fetchDiary()
        configure()
    }
    
}

extension DiaryListViewController {
    
    // MARK: - Configuration
    
    private func configure() {
        viewModel?.delegate = self
        configureNavigationBar()
        configureSubviews()
        configureConstraints()
        configureCollectionViewDataSource()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "다이어리 목록"
        navigationController?.navigationBar.tintColor = .primaryOrange
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didAddDiaryButtonTap)
        )
    }
    
    private func configureSubviews() {
        view.addSubview(collectionView)
        view.addSubview(placeholdLabel)
    }
    
    private func configureConstraints() {
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
        }
        
        placeholdLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc private func didAddDiaryButtonTap() {
        print("다이어리 추가버튼 탭")
    }
    
    // MARK: - Collection View
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            let sectionHeaderSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40)
            )
            
            // TODO: - 헤더 등록
            
            // section.boundarySupplementaryItems = []
            
            return section
        }
        return layout
    }
    
    private func configureCollectionViewDataSource() {
        
        let diaryCell = CellRegistration { cell, _, identifier in
            // TODO: - 셀 설정
            
        }
        
        diaryDataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: diaryCell,
                    for: indexPath,
                    item: item
                )
            }
        )
        
        // TODO: - 섹션 등록
            
        
    }
    
}

extension DiaryListViewController: DiaryListViewModelDelegate {
    
    func diaryInfoDidChage() {
        guard let viewModel = viewModel else { return }
        let diaryInfos = viewModel.diaryInfos
        
        placeholdLabel.isHidden = diaryInfos.isEmpty ? false : true
        var snapshot = SnapShot()
        
        diaryInfos.forEach { info in
            guard let travelID = info.travelID else { return }
            if !snapshot.sectionIdentifiers.contains(travelID) {
                snapshot.appendSections([travelID])
            }
            snapshot.appendItems([info], toSection: travelID)
        }
        
        diaryDataSource?.apply(snapshot, animatingDifferences: true)
    }
}
