//
//  PlanListViewController.swift
//  Doesaegim
//
//  Created by sun on 2022/11/15.
//

import UIKit

/// 일정을 조회, 추가, 삭제할 수 있는 뷰 컨트롤러
final class PlanListViewController: UIViewController {
    typealias DataSource =  UICollectionViewDiffableDataSource<Section, ItemID>
    typealias Section = String
    typealias ItemID = UUID

    // MARK: - UI Properties

    private lazy var collectionView = EmptyLabeledCollectionView(
        emptyLabelText: StringLiteral.emptyLabelText,
        collectionViewLayout: createLayout()
    )

    private lazy var dataSource = configureDataSource()


    // MARK: - Properties

    private let viewModel: PlanListViewModel

    private var sectionIdentifiers: [Section] {
        dataSource.snapshot().sectionIdentifiers
    }


    // MARK: - Init(s)

    init(viewModel: PlanListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Life Cycle

    override func loadView() {
        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureCollectionView()
        viewModel.fetchPlans()
    }

    // MARK: - NavigationBar Configuration Functions

    private func configureNavigationBar() {
        navigationItem.title = viewModel.navigationTitle
        setRightBarAddButton { [weak self] in
            if let travel = self?.viewModel.travel {
                let planAddViewController = PlanAddViewController(travel: travel)
                planAddViewController.delegate = self
                return planAddViewController
            } else {
                return UIViewController()
            }
        }
    }


    // MARK: - CollectionView Configuration Functions

    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .white
        configuration.headerMode = .supplementary
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(
                style: .destructive,
                title: StringLiteral.deleteActionTitle
            ) { _, _, _ in
                guard let id = self.dataSource.itemIdentifier(for: indexPath),
                      let section = self.sectionIdentifiers[safeIndex: indexPath.section]
                else { return }

                self.viewModel.deletePlan(in: section, id: id)
            }

            return .init(actions: [deleteAction])
        }

        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private func configureDataSource() -> DataSource {

        let cellRegistration = UICollectionView
            .CellRegistration<PlanCollectionViewCell, ItemID> { cell, indexPath, identifier in
                guard let section = self.sectionIdentifiers[safeIndex: indexPath.section]
                else {
                    return
                }

                let viewModel = self.viewModel.item(in: section, id: identifier)
                viewModel?.checkBoxToggleHandler = { [weak self, cell] result in
                    switch result {
                    case .success:
                        cell.render()
                    case .failure(let error):
                        self?.presentErrorAlert(
                            title: CoreDataError.saveFailure(.plan).localizedDescription,
                            message: error.localizedDescription
                        )
                    }
                }
                cell.viewModel = viewModel
                cell.checkBoxAction = UIAction { _ in viewModel?.checkBoxDidTap() }
        }

        let dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in

            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        /// 헤더 설정
        let headerRegistration = UICollectionView.SupplementaryRegistration<DateCollectionHeaderView>(
            elementKind: StringLiteral.sectionHeaderElementKind
        ) { supplementaryView, _, indexPath in
            supplementaryView.dateString = self.sectionIdentifiers[indexPath.section]
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }

        return dataSource
    }

    private func configureCollectionView() {
        collectionView.delegate = self
    }
}


// MARK: - Constants
fileprivate extension PlanListViewController {

    enum StringLiteral {

        static let emptyLabelText = "새로운 일정을 추가해주세요!"

        static let sectionHeaderElementKind = "UICollectionElementKindSectionHeader"

        static let deleteActionTitle = "일정 삭제"
    }
}


// MARK: - UICollectionViewDelegate 
extension PlanListViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.didPassPoint()
        else { return }

        viewModel.userDidScrollToEnd()
    }
}


// MARK: - PlanAddViewControllerDelegate
extension PlanListViewController: PlanAddViewControllerDelegate {
    func planAddViewControllerDidAddPlan(_ plan: Plan) {
        viewModel.addNewPlan(plan)
    }
}


// MARK: - PlanListViewModelDelegate
extension PlanListViewController: PlanListViewModelDelegate {

    func planListViewModelDidFetchPlans(_ result: Result<[PlanListSnapshotData], Error>) {
        switch result {
        case .success(let data):
            applySnapshot(usingData: data)
            collectionView.isEmpty = viewModel.planViewModels.isEmpty
        case .failure(let error):
            presentErrorAlert(
                title: CoreDataError.fetchFailure(.plan).localizedDescription,
                message: error.localizedDescription
            )
        }
    }

    func planListViewModelDidDeletePlan(_ result: Result<UUID, Error>) {
        var snapshot = self.dataSource.snapshot()

        switch result {
        case .success(let id):
            /// 섹션이 빈 경우 섹션도 삭제
            if let section = snapshot.sectionIdentifier(containingItem: id),
               viewModel.planViewModels[section] == nil {
                snapshot.deleteSections([section])
            }
            snapshot.deleteItems([id])
            dataSource.apply(snapshot, animatingDifferences: true)
            collectionView.isEmpty = viewModel.planViewModels.isEmpty == true
        case .failure(let error):
            presentErrorAlert(
                title: CoreDataError.deleteFailure(.plan).localizedDescription,
                message: error.localizedDescription
            )
        }
    }

    func planListViewModelDidAddPlan(_ result: Result<PlanListSnapshotData, Error>) {
        switch result {
        case .success(let data):
            updateSnapshot(byInsertingData: data)
            collectionView.isEmpty = viewModel.planViewModels.isEmpty
        case .failure(let error):
            presentErrorAlert(
                title: CoreDataError.fetchFailure(.plan).localizedDescription,
                message: error.localizedDescription
            )
        }
    }

    /// 새롭게 불러온 데이터만을 반영해서 스냅샷을 갱신
    private func applySnapshot(usingData data: [PlanListSnapshotData]) {
        var snapshot = self.dataSource.snapshot()

        data.forEach {
            if !snapshot.sectionIdentifiers.contains($0.section) {
                snapshot.appendSections([$0.section])
            }
            snapshot.appendItems([$0.itemID], toSection: $0.section)
        }
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    /// 유저가 새로 추가한 일정 데이터만을 반영해서 스냅샷을 갱신
    private func updateSnapshot(byInsertingData data: PlanListSnapshotData) {
        guard let row = data.row
        else {
            return
        }

        var snapshot = self.dataSource.snapshot()

        if !snapshot.sectionIdentifiers.contains(data.section) {
            if let index = snapshot.sectionIdentifiers.firstIndex(where: { data.section > $0 }) {
                snapshot.insertSections([data.section], beforeSection: snapshot.sectionIdentifiers[index])
            } else {
                snapshot.appendSections([data.section])
            }
        }

        guard let previousItem = snapshot.itemIdentifiers(inSection: data.section)[safeIndex: row]
        else {
            /// 맨 뒤에 추가하는 경우
            snapshot.appendItems([data.itemID], toSection: data.section)
            dataSource.apply(snapshot, animatingDifferences: false)
            return
        }

        snapshot.insertItems([data.itemID], beforeItem: previousItem)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
