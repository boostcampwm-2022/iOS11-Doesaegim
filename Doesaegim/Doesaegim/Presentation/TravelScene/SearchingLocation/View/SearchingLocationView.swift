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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.backgroundColor = .grey2?.withAlphaComponent(Metric.IndicatorBackgroundAlpha)
        
        return indicator
    }()
    
    /// 검색 결과를 표시하는 컬렉션 뷰
    lazy var searchResultCollectionView: EmptyLabeledCollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = EmptyLabeledCollectionView(
            emptyLabelText: StringLiteral.emptyLabelText,
            frame: .zero,
            collectionViewLayout: layout
        )
        
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
    
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        backgroundColor = .white
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        addSubviews(searchResultCollectionView, activityIndicator)
    }
    
    private func configureConstraints() {
        searchResultCollectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        activityIndicator.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: - Activity Indicator Functions
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}

fileprivate extension SearchingLocationView {
    enum Metric {
        static let IndicatorBackgroundAlpha: CGFloat = 0.7
    }
    
    enum StringLiteral {
        static let emptyLabelText = "장소 검색 결과가 없습니다."
    }
}
