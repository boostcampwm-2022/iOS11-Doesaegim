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
    typealias Section = Int
    typealias ItemID = UUID

    // MARK: - UI Properties

    private lazy var collectionView = EmptyLabeledCollectionView(
        emptyLabelText: StringLiteral.emptyLabelText,
        collectionViewLayout: createLayout()
    )

    private lazy var dataSource = configureDataSource()


    // MARK: - Properties

    private let viewModel: PlanListViewModel


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
        bindToViewModel()
        fetchPlans()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = false
    }


    // MARK: - NavigationBar Configuration Functions

    private func configureNavigationBar() {
        navigationItem.title = viewModel.navigationTitle
        // TODO: 일정 추가 화면으로 교체
        let nextViewController = PlanAddViewController()
        setRightBarAddButton(showing: nextViewController)
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
                do {
                    try self.viewModel.deletePlan(at: indexPath)
                } catch let error {
                    self.presentErrorAlert(
                        title: CoreDataError.deleteFailure.localizedDescription,
                        message: error.localizedDescription
                    )
                }
            }

            return .init(actions: [deleteAction])
        }

        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private func configureDataSource() -> DataSource {

        let cellRegistration = UICollectionView
            .CellRegistration<PlanCollectionViewCell, ItemID> { cell, indexPath, identifier in
                let viewModel = self.viewModel.item(at: indexPath, withID: identifier)
                cell.viewModel = viewModel
                cell.checkBoxAction = UIAction { _ in
                    do {
                        try viewModel?.checkBoxDidTap()
                    } catch let error {
                        self.presentErrorAlert(
                            title: CoreDataError.saveFailure.localizedDescription,
                            message: error.localizedDescription
                        )
                    }
                }
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
            supplementaryView.dateString = self.viewModel.title(forSection: indexPath.section)
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }

        return dataSource
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemID>()

        viewModel.planViewModels.enumerated().forEach { section, items in
            let itemIdentifiers = items.map { $0.id }
            guard !itemIdentifiers.isEmpty
            else {
                return
            }

            snapshot.appendSections([section])
            snapshot.appendItems(itemIdentifiers, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func fetchPlans() {
        do {
            try viewModel.fetch()
        } catch let error {
            self.presentErrorAlert(
                title: CoreDataError.fetchFailure.localizedDescription,
                message: error.localizedDescription
            )
        }
    }


    // MARK: - ViewModel Configuration Functions

    private func bindToViewModel() {
        viewModel.planFetchHandler = { [weak self] isEmpty in
            self?.applySnapshot()
            self?.collectionView.isEmpty = isEmpty
        }
        viewModel.planDeleteHandler = { [weak self] in
            guard var snapshot = self?.dataSource.snapshot()
            else { return }

            snapshot.deleteItems([$0])
            self?.dataSource.apply(snapshot, animatingDifferences: true)
            self?.collectionView.isEmpty = self?.viewModel.planViewModels.isEmpty == true
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
