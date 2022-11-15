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
    
    // MARK: - Properties
    
    let placeholderLabel: UILabel = {
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        configureNavigationBar()
        configureSubviews()
        configureConstratins()
    }

    // MARK: - Configure
    
    func configureNavigationBar() {
        navigationItem.title = "여행 목록"
    }
    
    func configureSubviews() {
        view.addSubview(collectionView)
        view.addSubview(placeholderLabel)
    }
    
    func configureConstratins() {
        placeholderLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(16)
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(view.snp.bottom)
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
        let travelCell = UICollectionView.CellRegistration<ExpenseTravelViewCell, TravelInfoViewModel> {
            cell, indexPath, identifier in
            
            // TODO: - 과정 처리 셀 클래스로 넘기는 것 고민
            var content = cell.defaultContentConfiguration()
            content.attributedText = NSAttributedString(
                string: identifier.title,
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 20),
                    .foregroundColor: UIColor.black
                ]
            )
            content.secondaryAttributedText = NSAttributedString(
                string: Date.convertTravelString(
                    start: identifier.startDate,
                    end: identifier.endDate
                ),
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.grey2
                        
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
