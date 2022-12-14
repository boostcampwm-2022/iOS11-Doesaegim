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
            cell.setupCellStatus(with: identifier.isSelected)
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

extension FaceDetectController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. viewModel의 detectInfo -> indexPath.row 번째 모델을 조회
        // 2. isSelected프로퍼티를 셀의 메서드에 전달한다.
        // 3. 메서드에서 알아서 결정
        
        guard let viewModel = viewModel,
              indexPath.row < viewModel.detectInfos.count,
              let cell = collectionView.cellForItem(at: indexPath) as? DetectedFaceCell else { return }
        
        let isSelected = viewModel.detectInfos[indexPath.row].isSelected
        viewModel.detectInfos[indexPath.row].isSelected.toggle() // 값을 뒤집어준다.
        cell.setupCellStatus(with: isSelected)
        
    }
}
