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
        = UICollectionViewDiffableDataSource<String, DiaryInfoViewModel>
    typealias CellRegistration
        = UICollectionView.CellRegistration<DiaryListCell, DiaryInfoViewModel>
    typealias SnapShot
        = NSDiffableDataSourceSnapshot<String, DiaryInfoViewModel>
    typealias HeaderRegistration
        = UICollectionView.SupplementaryRegistration<DiaryListHeaderView>
    
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

        configure()
        
        viewModel?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel?.fetchDiary()
    }
}

extension DiaryListViewController {
    
    // MARK: - Configuration
    
    private func configure() {
        collectionView.delegate = self
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
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc private func didAddDiaryButtonTap() {
        let diaryAddViewController = DiaryAddViewController()
        diaryAddViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(diaryAddViewController, animated: true)
    }
    
    // MARK: - Collection View
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(80)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 3, bottom: 4, trailing: 3)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(80)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)

            let sectionHeaderSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: sectionHeaderSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
        
        return layout
    }
    
    private func configureCollectionViewDataSource() {
        
        var uuid: UUID?
        let diaryCell = CellRegistration { cell, _, identifier in
            // TODO: - 셀 설정
            cell.configureData(with: identifier)
            uuid = identifier.travelID
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
        
        let headerRegistration = HeaderRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { _, _, _ in
        }
        
        // TODO: - 섹션 등록
            
        diaryDataSource?.supplementaryViewProvider = { [weak self] (collectionView, _, indexPath) in
            
            let sectionHeader = collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
            
            guard let viewModel = self?.viewModel,
                  let travelDiaryInfo = viewModel.travelDiaryInfos[safeIndex: indexPath.section] else {
                return UICollectionReusableView()
            }
            let travelName = travelDiaryInfo.name
            sectionHeader.configureData(with: travelName)
            
            return sectionHeader
        }
    }
    
}

extension DiaryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - 다이어리 선택 뷰, safe index 설정
        guard let viewModel = viewModel,
              let travelDiaryInfo = viewModel.travelDiaryInfos[safeIndex: indexPath.section],
              let diary = travelDiaryInfo.info[safeIndex: indexPath.row] else { return }
        // sectionDictionary는 Array가 아니라 Dictionary이기 때문에 safeIndex가 적용되지 않는다.
        // 어차피 없는 Key값이라면 nil이 반환되기 때문에 indexPath.section이 올바른 범위에 있는지도 확인할 필요가 없다.
        
        // uuid를 생성자에 넘기고 다이어리 디테일 뷰 푸시
        let uuid = diary.id
        
        let controller = DiaryDetailViewController(id: uuid)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - DiaryListViewModelDelegate

extension DiaryListViewController: DiaryListViewModelDelegate {
    
    func diaryInfoDidChage() {
        guard let viewModel = viewModel else { return }
        
        let travelDiaryInfos = viewModel.travelDiaryInfos
        placeholdLabel.isHidden = !travelDiaryInfos.isEmpty
        
        var snapshot = SnapShot()
        
        travelDiaryInfos.forEach { travelDiary in
            // 여행종류마다 튜플로 구분되어 있으므로, 해당 섹션이 이미 존재하는지 확인할 필요가 없다. 없음이 명확하다.
            snapshot.appendSections([travelDiary.name])
            snapshot.appendItems(travelDiary.info, toSection: travelDiary.name)
        }
        
        diaryDataSource?.apply(snapshot, animatingDifferences: true)
        
    }
    
    func diaryListFetchDidFail() {
        let alert = UIAlertController(
            title: "불러오기 실패",
            message: "다이어리 정보를 불러오는데 실패하였습니다",
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

extension DiaryListViewController {
    
    private func deleteDiary(with diaryInfo: DiaryInfoViewModel) {
        let travelID = diaryInfo.travelID
        let dairyID = diaryInfo.id
        // TODO: - 뷰모델 삭제 메서드 호출
    }
    
    private func makeSwipeAction(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath,
              let identifier = diaryDataSource?.itemIdentifier(for: indexPath) else { return nil }
        let deleteActionTitle = NSLocalizedString("삭제", comment: "다이어리 삭제")
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: deleteActionTitle
        ) { [weak self] _, _, completion in
            self?.deleteDiary(with: identifier)
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
      }
    
}
