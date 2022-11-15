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
    
    /// 서치바 텍스트필드 영역
    let searchBarField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .grey1
        textField.layer.cornerRadius = Metric.searchBarCornerRadius
        
        let searchIconImageView = UIImageView(
            image: UIImage(systemName: StringLiteral.searchBarIcon)
        )
        searchIconImageView.tintColor = .grey4
        textField.leftView = searchIconImageView
        textField.leftViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    /// 검색 결과를 표시하는 컬렉션 뷰
    lazy var searchResultCollectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    /// 서치바 마진 영역
    private let searchBarMarginView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// 서치바와 검색 결과 리스트를 포함하는 스택뷰
    private let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.contentStackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
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
        searchBarMarginView.addSubview(searchBarField)
        
        contentStack.addArrangedSubview(searchBarMarginView)
        contentStack.addArrangedSubview(searchResultCollectionView)
        
        addSubview(contentStack)
    }
    
    private func configureConstraints() {
        searchBarField.snp.makeConstraints {
            $0.height.equalTo(Metric.searchBarHeight)
            $0.horizontalEdges.equalTo(searchBarMarginView).inset(Metric.searchBarHorizontalPadding)
            $0.verticalEdges.equalTo(searchBarMarginView)
        }
        
        contentStack.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
    }
}

// MARK: - Namespaces Extension

extension SearchingLocationView {
    enum Metric {
        static let searchBarHorizontalPadding: CGFloat = 16
        static let searchBarHeight: CGFloat = 36
        static let searchBarCornerRadius: CGFloat = 10
        
        static let contentStackSpacing: CGFloat = 16
    }
    
    enum StringLiteral {
        static let searchBarIcon = "magnifyingglass"
    }
}
