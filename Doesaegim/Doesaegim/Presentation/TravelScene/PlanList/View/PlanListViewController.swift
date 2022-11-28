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
        bindToViewModel()
        viewModel.fetchPlans()
    }

    // MARK: - NavigationBar Configuration Functions

    private func configureNavigationBar() {
        navigationItem.title = viewModel.navigationTitle
        setRightBarAddButton { [weak self] in
            if let travel = self?.viewModel.travel {
                return PlanAddViewController(travel: travel)
            } else {
                return UIViewController()
            }
        }
    }


    // MARK: - CollectionView Configuration Functions

    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .supplementary
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(
                style: .destructive,
                title: StringLiteral.deleteActionTitle
            ) { _, _, _ in
                guard let id = self.dataSource.itemIdentifier(for: indexPath)
                else { return }

                let section = self.sectionIdentifiers[indexPath.section]
                self.viewModel.deletePlan(in: section, id: id)
            }

            return .init(actions: [deleteAction])
        }

        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private func configureDataSource() -> DataSource {

        let cellRegistration = UICollectionView
            .CellRegistration<PlanCollectionViewCell, ItemID> { cell, indexPath, identifier in
                let section = self.sectionIdentifiers[indexPath.section]
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

    /// 새롭게 추가된 데이터만을 반영해서 스냅샷을 갱신
    private func applySnapshot(usingData data: [(Section, ItemID)]) {
        var snapshot = self.dataSource.snapshot()

        data.forEach { section, itemID in
            if !snapshot.sectionIdentifiers.contains(section) {
                snapshot.appendSections([section])
            }

            snapshot.appendItems([itemID], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func configureCollectionView() {
        collectionView.delegate = self
    }


    // MARK: - ViewModel Configuration Functions

    private func bindToViewModel() {
        viewModel.planFetchHandler = { [weak self] result in
            switch result {
            case .success(let data):
                self?.applySnapshot(usingData: data)
                self?.collectionView.isEmpty = self?.viewModel.planViewModels.isEmpty == true
            case .failure(let error):
                self?.presentErrorAlert(
                    title: CoreDataError.fetchFailure(.plan).localizedDescription,
                    message: error.localizedDescription
                )
            }
        }

        viewModel.planDeleteHandler = { [weak self] result in
            guard var snapshot = self?.dataSource.snapshot()
            else { return }

            switch result {
            case .success(let id):
                /// 섹션이 빈 경우 섹션도 삭제
                if let section = snapshot.sectionIdentifier(containingItem: id),
                   self?.viewModel.planViewModels[section] == nil {
                    snapshot.deleteSections([section])
                }
                snapshot.deleteItems([id])
                self?.dataSource.apply(snapshot, animatingDifferences: true)
                self?.collectionView.isEmpty = self?.viewModel.planViewModels.isEmpty == true
            case .failure(let error):
                self?.presentErrorAlert(
                    title: CoreDataError.deleteFailure(.plan).localizedDescription,
                    message: error.localizedDescription
                )
            }
        }
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
