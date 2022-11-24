//
//  DiaryListViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/24.
//

import UIKit


import SnapKit

final class DiaryListViewController: UIViewController {
    
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
    
    // MARK: - Initializer(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
    }
    
    private func configureConstraints() {
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
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
    
}

extension DiaryListViewController: DiaryListViewModelDelegate {
    
    func diaryInfoDidChage() {
        print(#function)
    }
}
