//
//  SearchingLocationViewController.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/15.
//

import UIKit

final class SearchingLocationViewController: UIViewController {
    // MARK: - UI Properties
    
    private let rootView = SearchingLocationView()
    
    private var resultViewDataSource: UICollectionViewDiffableDataSource<Section, SearchResultCellViewModel>?
    
    // MARK: - Properties
    
    // TODO: 더미 데이터. 추후 삭제
    private let dummies = [
        SearchResultCellViewModel(name: "1. 네이버 1784", address: "경기 성남시 분당구", latitude: 0.0, longitude: 0.0),
        SearchResultCellViewModel(name: "2. 네이버 1784", address: "경기 성남시 분당구", latitude: 0.0, longitude: 0.0),
        SearchResultCellViewModel(name: "3. 네이버 1784", address: "경기 성남시 분당구", latitude: 0.0, longitude: 0.0),
        SearchResultCellViewModel(name: "4. 네이버 1784", address: "경기 성남시 분당구", latitude: 0.0, longitude: 0.0),
        SearchResultCellViewModel(name: "5. 네이버 1784", address: "경기 성남시 분당구", latitude: 0.0, longitude: 0.0)
    ]
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureCollectionView()
    }
    
    // MARK: - Configure Functions
    
    private func configureNavigationBar() {
        title = "장소 검색"
    }
    
    /// 컬렉션뷰 셀 등록, DiffableDataSource 정의, 델리게이트 지정을 수행한다.
    private func configureCollectionView() {
        configureCollectionViewDataSource()
        configureCollectionViewDelegates()
        applySnapshot()
    }
    
    /// 컬렉션뷰에 사용될 셀을 등록하고, DiffableDataSource를 정의한다.
    private func configureCollectionViewDataSource() {
        let cellRegistration = UICollectionView
            .CellRegistration<SearchResultCell, SearchResultCellViewModel>(
                handler: { cell, _, viewModel in
            cell.setupLabels(name: viewModel.name, address: viewModel.address)
        })
        
        resultViewDataSource = UICollectionViewDiffableDataSource<Section, SearchResultCellViewModel>(
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
    private func applySnapshot() {
        guard var snapshot = resultViewDataSource?.snapshot()
        else { return }
        
        snapshot.appendSections([.main])
        snapshot.appendItems(dummies)
        
        resultViewDataSource?.apply(snapshot)
    }
}

// MARK: - SearchingLocationViewController.Section

extension SearchingLocationViewController {
    enum Section {
        case main
    }
}

// MARK: - UICollectionViewDelegate

extension SearchingLocationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 선택된 셀의 장소 데이터를 가지고 이전 화면으로 돌아가기 구현 필요
        navigationController?.popViewController(animated: true)
    }
}
