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
    
    func configureCollectionView() {
        // 따로 identifier로 사용할 뷰모델이 없으므로 register메서드 통해 등록
        collectionView.register(
            DetectedFaceCell.self,
            forCellWithReuseIdentifier: DetectedFaceCell.identifier
        )
    }
    
    func configureCollectionViewDataSource() {
        
        detectDataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, _ in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DetectedFaceCell.identifier,
                    for: indexPath
                ) as? DetectedFaceCell
                
                // TODO: - 셀 이미지 크롭
                let dummyImage = UIImage(systemName: "photo")
                cell?.configureImage(with: dummyImage)
                
                return cell
            }
        )
        
    }
    
}


// MARK: - Layout

extension FaceDetectController {
    
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
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item, item, item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
    
}
