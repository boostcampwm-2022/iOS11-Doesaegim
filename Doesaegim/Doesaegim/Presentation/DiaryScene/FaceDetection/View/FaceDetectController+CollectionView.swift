//
//  FaceDetectController+CollectionView.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/29.
//

import UIKit


extension FaceDetectController {
    
    enum SectionType {
        case main
    }
    
    // MARK: - Collection View Configuration
    
    func configureCollectionViewDataSource() {
        
        let detectedCell = CellRegistration { cell, _, identifier in
            cell.configureInfo(with: identifier)
        }
        
        detectDataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                return collectionView.dequeueConfiguredReusableCell(
                    using: detectedCell,
                    for: indexPath,
                    item: itemIdentifier
                )
            }
        )
        
    }
    
    // MARK: - Layout
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {_, _ -> NSCollectionLayoutSection? in
            // 너비 == 높이 인 정사각형의 사이즈
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalWidth(1/3)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1/3)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
    
}
