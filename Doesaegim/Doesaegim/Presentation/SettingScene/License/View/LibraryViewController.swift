//
//  LibraryViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/08.
//

import UIKit



final class LibraryViewController: UIViewController {

    private typealias DataSource
        = UICollectionViewDiffableDataSource<LicenseSection, LibraryInfoViewModel>
    private typealias SnapShot
        = NSDiffableDataSourceSnapshot<LicenseSection, LibraryInfoViewModel>
    private typealias CellRegistration
        = UICollectionView.CellRegistration<LibraryCollectionViewCell, LibraryInfoViewModel>
    
    private lazy var licenseCollectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.layer.cornerRadius = 10
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    private var licenseDataSource: DataSource?
    
    private var viewModel: LibraryViewModelProtocol = LibraryViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
    
}

extension LibraryViewController {
    
    // MARK: - Configuration
    
    private func configure() {
        viewModel.delegate = self
        
        configureView()
        configureNavigationBar()
        configureSubviews()
        configureConstraints()
        configureCollectionView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "라이센스"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSubviews() {
        view.addSubview(licenseCollectionView)
    }
    
    private func configureConstraints() {
        licenseCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    // MARK: - ConfigureCollectionView
    
    private func configureCollectionView() {
        configureDataSource()
    }
    
    private func configureDataSource() {
        
        let licenseCell = CellRegistration { cell, _, identifier in
            cell.configure(with: identifier)
        }
        
        licenseDataSource = DataSource(
            collectionView: licenseCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                return collectionView.dequeueConfiguredReusableCell(
                    using: licenseCell,
                    for: indexPath,
                    item: itemIdentifier
                )
            }
        )
        
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let heightDimension = NSCollectionLayoutDimension.estimated(100)
        
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: heightDimension
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: .fixed(0),
                top: .fixed(6),
                trailing: .fixed(0),
                bottom: .fixed(6)
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            
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

extension LibraryViewController: LibraryViewModelDelegate {
    
    func licenseViewShouldUpdated() {
        
        var snapShot = SnapShot()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(viewModel.licenseInfos)
        print(viewModel.licenseInfos)
        
        licenseDataSource?.apply(snapShot, animatingDifferences: true)
        
    }
}

// MARK: - Data

extension LibraryViewController {
    enum LicenseSection {
        case main
    }
}
