//
//  SearchingLocationViewController.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/15.
//

import UIKit

final class SearchingLocationViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, SearchResultCellViewModel>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, SearchResultCellViewModel>
    typealias CellRegistration = UICollectionView
                                    .CellRegistration<SearchResultCell, SearchResultCellViewModel>
    
    // MARK: - UI Properties
    
    private let rootView = SearchingLocationView()
    
    // MARK: - Properties
    
    private var resultViewDataSource: DataSource?
    
    private let viewModel = SearchingLocationViewModel()
    
    weak var delegate: SearchingLocationViewControllerDelegate?
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSearchController()
        configureCollectionView()
        configureViewModelDelegate()
    }
    
    // MARK: - Configure Functions
    
    private func configureNavigationBar() {
        title = StringLiteral.title
    }
    
    /// 서치바가 포함된 UISearchController를 설정한다.
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = StringLiteral.searchBarPlaceholder
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    /// 컬렉션뷰 셀 등록, DiffableDataSource 정의, 델리게이트 지정을 수행한다.
    private func configureCollectionView() {
        configureCollectionViewDataSource()
        configureCollectionViewDelegates()
        configureSnapshot()
    }
    
    /// SearchingLocationViewModel의 델리게이트를 지정한다.
    private func configureViewModelDelegate() {
        viewModel.delegate = self
    }
    
    // MARK: - Configure CollectionView Functions
    
    /// 컬렉션뷰에 사용될 셀을 등록하고, DiffableDataSource를 정의한다.
    private func configureCollectionViewDataSource() {
        let cellRegistration = CellRegistration(handler: { cell, _, viewModel in
            cell.setupLabels(name: viewModel.name, address: viewModel.address)
        })
        
        resultViewDataSource = DataSource(
            collectionView: rootView.searchResultCollectionView
        ) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
            
            return cell
        }
    }
    
    /// 컬렉션뷰의 델리게이트를 지정한다.
    private func configureCollectionViewDelegates() {
        rootView.searchResultCollectionView.delegate = self
        rootView.searchResultCollectionView.dataSource = resultViewDataSource
    }
    
    /// 설정한 DiffableDataSource에 snapshot을 적용한다.
    private func configureSnapshot() {
        var snapshot = SnapShot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.searchResultCellViewModels)
        
        resultViewDataSource?.apply(snapshot)
    }
}

// MARK: - SearchingLocationViewController.Section

extension SearchingLocationViewController {
    enum Section {
        case main
    }
}

// MARK: - UISearchBarDelegate

extension SearchingLocationViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text
        else { return }
        
        viewModel.fetchSearchResults(with: keyword)
    }
}

// MARK: - UICollectionViewDelegate

extension SearchingLocationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = viewModel.searchResultCellViewModels[safeIndex: indexPath.row]
        else {
            return
        }

        let selectedLocation = LocationDTO(
            name: selectedItem.name,
            latitude: selectedItem.latitude,
            longitude: selectedItem.longitude
        )
        delegate?.searchingLocationViewController(didSelect: selectedLocation)
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - SearchingLocationViewModelDelegate

extension SearchingLocationViewController: SearchingLocationViewModelDelegate {
    
    func searchLocationWillStart() {
        rootView.startAnimating()
    }
    
    func searchLocaitonResultDidChange() {
        rootView.searchResultCollectionView.isEmpty = viewModel.searchResultCellViewModels.isEmpty
        rootView.stopAnimating()
        configureSnapshot()
    }
    
    func searchLocationErrorOccurred() {
        presentErrorAlert(title: StringLiteral.responseErrorTitle)
    }
}


// MARK: - Namespaces

extension SearchingLocationViewController {
    enum StringLiteral {
        static let title = "장소 검색"
        static let searchBarPlaceholder = "장소명을 입력해주세요."
        
        static let responseErrorTitle = "검색 결과 요청에 실패했습니다."
    }
}
