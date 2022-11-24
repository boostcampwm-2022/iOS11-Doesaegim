//
//  DiaryListViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/24.
//

import UIKit


final class DiaryListViewController: UIViewController {
    
    // MARK: - Properties
    
    // TODO: - 나중에 생성자로 주입
    private let viewModel: DiaryListViewModelProtocol? = DiaryListViewModel()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
    }()
    
    // MARK: - Initializer(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
    
}

extension DiaryListViewController {
    
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
