//
//  ExpenseViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit

import SnapKit

final class ExpenseTravelListController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<String, TravelInfoViewModel>
    typealias SnapShot = NSDiffableDataSourceSnapshot<String, TravelInfoViewModel>
    typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, TravelInfoViewModel>
    
    // MARK: - Properties
    
    let placeholdLabel: UILabel = {
        let label = UILabel()
        label.text = "일정 탭에서 새로운 여행을 추가해주세요!"
        label.textColor = .grey2
        
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = collectionViewListLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 7
        
        return collectionView
    }()
    
    var travelDataSource: DataSource?
    
    var viewModel: ExpenseTravelViewModelProtocol? = ExpenseTravelViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewModel?.delegate = self
        
        configureNavigationBar()
        configureSubviews()
        configureConstratins()
        configureCollectionViewDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchTravelInfo()
    }

    // MARK: - Configure
    
    func configureNavigationBar() {
        navigationItem.title = "여행 목록"
    }
    
    func configureSubviews() {
        view.addSubview(collectionView)
        view.addSubview(placeholdLabel)
    }
    
    func configureConstratins() {
        placeholdLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(0)
        }
    }
    
    // MARK: - Collection View
    
    private func collectionViewListLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .white
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func configureCollectionViewDataSource() {
        let travelCell =  CellRegistration { cell, _, identifier in
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
                    .foregroundColor: UIColor.grey2!
                        
                ]
            )
            cell.contentConfiguration = content
        }
        
        travelDataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: travelCell,
                    for: indexPath,
                    item: item
                )
            }
        )   
    }
}

// MARK: - ExpenseTravelViewModelDelegate

extension ExpenseTravelListController: ExpenseTravelViewModelDelegate {
    
    func travelListSnapshotShouldChange() {
        // TODO: - ViewModel 작성 후 identifierItem 작성
        print(#function)
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
        print(#function)
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
