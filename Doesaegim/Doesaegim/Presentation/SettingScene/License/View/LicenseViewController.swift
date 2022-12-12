//
//  LicenseViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/08.
//

import UIKit

final class LicenseViewController: UIViewController {

    lazy var licenseCollectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.layer.cornerRadius = 10
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension LicenseViewController {
    
    // MARK: - ConfigureCollectionView
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let heightDimension = NSCollectionLayoutDimension.estimated(70)
        
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: heightDimension
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: .fixed(0),
                top: .fixed(4),
                trailing: .fixed(0),
                bottom: .fixed(4)
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: heightDimension
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        return layout
    }
    
}
