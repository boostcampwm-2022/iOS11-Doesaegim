//
//  SearchingLocationView.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/14.
//

import UIKit

import SnapKit

final class SearchingLocationView: UIView {
    
    // MARK: - UI Properties
    
    /// 검색 결과를 표시하는 컬렉션 뷰
    lazy var searchResultCollectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViews()
    }
    
    
    // MARK: - Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        addSubview(searchResultCollectionView)
    }
    
    private func configureConstraints() {
        searchResultCollectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
