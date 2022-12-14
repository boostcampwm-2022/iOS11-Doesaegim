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
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ItemID>
    typealias Section = Date
    typealias ItemID = UUID

    // MARK: - UI Properties

    private lazy var collectionView = EmptyLabeledCollectionView(
        emptyLabelText: StringLiteral.emptyLabelText,
        collectionViewLayout: createLayout()
    )

    private lazy var dataSource = configureDataSource()

    private var previousDate: Date?


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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewWillAppear()
    }


    // MARK: - NavigationBar Configuration Functions

    private func configureNavigationBar() {
        navigationItem.title = viewModel.navigationTitle
        let ellipsisButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: nil
        )
        
        let moveToPlanAddViewControllerAction = UIAction(
            title: "일정 추가 하기"
        ) { [weak self] _  in
                if let travel = self?.viewModel.travel {
                    let planAddViewController = PlanAddViewController(travel: travel, mode: .post)
                    planAddViewController.delegate = self
                    self?.navigationController?.pushViewController(planAddViewController, animated: true)
                } else {
                    self?.presentErrorAlert(title: "일정을 추가할 수 없어요.")
                }
            }
        
        let moveToUpdateTravelAction = UIAction(
            title: "여행 수정 하기"
        ) { [weak self] _ in
            let travelAddViewController = TravelWriteViewController(
                mode: .update,
                travel: self?.viewModel.travel
            )
            self?.navigationController?.pushViewController(travelAddViewController, animated: true)
        }
        let cancel = UIAction(title: "취소", attributes: .destructive) { _ in }
        
        ellipsisButton.menu = UIMenu(
            title: "이동하기",
            options: .displayInline,
            children: [moveToPlanAddViewControllerAction,moveToUpdateTravelAction, cancel]
        )
        navigationItem.rightBarButtonItem = ellipsisButton
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
        ) { [weak self] supplementaryView, _, indexPath in
            guard let sectionIdentifier = self?.sectionIdentifiers[safeIndex: indexPath.section]
            else {
                return
            }

            supplementaryView.dateString = self?.viewModel.dateString(forSection: sectionIdentifier)
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

        static let updateUnavailableError = "변경 사항을 반영할 수 없습니다."
    }
}


// MARK: - UICollectionViewDelegate 
extension PlanListViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.didPassPoint()
        else { return }

        viewModel.userDidScrollToEnd()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = dataSource.itemIdentifier(for: indexPath),
              let section = sectionIdentifiers[safeIndex: indexPath.section],
              let plan = viewModel.item(in: section, id: id)?.plan
        else {
            return
        }

        let planAddViewController = PlanAddViewController(travel: viewModel.travel, mode: .detail, plan: plan)
        planAddViewController.delegate = self
        previousDate = plan.date
        navigationController?.pushViewController(planAddViewController, animated: true)
    }
}


// MARK: - PlanWriteViewControllerDelegate
extension PlanListViewController: PlanWriteViewControllerDelegate {
    func planWriteViewControllerDidAddPlan(_ plan: Plan) {
        viewModel.addNewPlan(plan)
    }

    func planWriteViewControllerDidUpdatePlan(_ plan: Plan) {
        var snapshot = dataSource.snapshot()
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first,
              let itemIdentifier = dataSource.itemIdentifier(for: indexPath),
              let section = snapshot.sectionIdentifier(containingItem: itemIdentifier),
              let date = plan.date
        else {
            presentErrorAlert(title: StringLiteral.updateUnavailableError)
            return
        }

        guard date == previousDate
        else {
            viewModel.update(plan, previousSection: section)
            return
        }

        snapshot.reloadItems([itemIdentifier])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}


// MARK: - PlanListViewModelDelegate
extension PlanListViewController: PlanListViewModelDelegate {

    func planListViewModelDidFetchPlans(_ result: Result<[PlanListSnapshotData], Error>) {
        switch result {
        case .success(let data):
            applySnapshot(usingData: data, snapshot: dataSource.snapshot())
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

    func planListViewModelDidUpdateDateFormat() {
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections(snapshot.sectionIdentifiers)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func planListViewModelDidUpdatePlans(_ result: Result<[PlanListSnapshotData], Error>) {
        switch result {
        case .success(let data):
            applySnapshot(usingData: data, snapshot: Snapshot())
            collectionView.isEmpty = viewModel.planViewModels.isEmpty
        case .failure(let error):
            presentErrorAlert(
                title: CoreDataError.updateFailure(.plan).localizedDescription,
                message: error.localizedDescription
            )
        }
    }

    /// 새롭게 불러온 데이터만을 반영해서 스냅샷을 갱신
    private func applySnapshot(usingData data: [PlanListSnapshotData], snapshot: Snapshot) {
        var snapshot = snapshot

        data.forEach {
            if !snapshot.sectionIdentifiers.contains($0.section) {
                snapshot.appendSections([$0.section])
            }
            snapshot.appendItems([$0.itemID], toSection: $0.section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
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
