//
//  ImageSliderView.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/12/07.
//

import UIKit

final class ImageSliderView: UIView {
    
    // MARK: - UI Properties
    
    /// 이미지 슬라이더 뷰.
    private(set) lazy var slider: UICollectionView = {
        let layout = configureCompositionalLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsSelection = false
        
        return collectionView
    }()
    
    /// 페이지 컨트롤
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .grey1
        control.currentPageIndicatorTintColor = .primaryOrange
        control.isUserInteractionEnabled = false
        control.hidesForSinglePage = true
        
        return control
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        
        return stack
    }()
    
    // MARK: - Properties
    
    weak var delegate: UICollectionViewDelegate? {
        get { slider.delegate }
        set { slider.delegate = newValue }
    }
    
    weak var dataSource: UICollectionViewDataSource? {
        get { slider.dataSource }
        set { slider.dataSource = newValue }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Function
    
    private func configureViews() {
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        contentStack.addArrangedSubviews(slider, pageControl)
        addSubview(contentStack)
    }
    
    private func configureConstraints() {
        contentStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: - Layout Functions
    
    /// 이미지 슬라이더의 레이아웃을 생성한다.
    private func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layoutSize = configureImageSliderLayoutSize()
        let subitem = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitems: [subitem]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, _, _ in
            self?.setupCurrentPage(visibleItems.last?.indexPath.row ?? .zero)
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    
    /// 이미지 슬라이더 레이아웃의 크기를 지정한다.
    private func configureImageSliderLayoutSize() -> NSCollectionLayoutSize {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Metric.one),
            heightDimension: .fractionalWidth(Metric.one)
        )
        return layoutSize
    }
    
    // MARK: - Setup Functions
    
    func setupNumberOfPages(_ count: Int) {
        pageControl.numberOfPages = count
    }
    
    func setupCurrentPage(_ pageIndex: Int) {
        pageControl.currentPage = pageIndex
    }
    
    func setupImageSliderShowing(with isHidden: Bool) {
        slider.isHidden = isHidden
    }
}

extension ImageSliderView {
    enum Metric {
        static let one: CGFloat = 1
    }
}
