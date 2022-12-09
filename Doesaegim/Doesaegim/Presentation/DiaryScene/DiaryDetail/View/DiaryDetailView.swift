//
//  DiaryDetailView.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import UIKit

import SnapKit

final class DiaryDetailView: UIView {
    // MARK: - UI Properties
    
    /// 다이어리 조회 중 나타나는 액티비티 인디케이터 뷰
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        
        return indicator
    }()
    
    /// 이미지 슬라이더 뷰.
    lazy var imageSlider = ImageSliderView()
    
    /// 내용 레이블
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Metric.contentNumberOfLines
        
        return label
    }()
    
    /// 장소 레이블
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.changeFontSize(to: FontSize.body)
        
        return label
    }()
    
    /// 날짜 레이블
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.changeFontSize(to: FontSize.caption)
        label.textColor = .grey3
        
        return label
    }()
    
    /// 장소, 날짜 레이블을 포함한 스택 뷰
    private let infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.infoStackSpacing
        
        return stackView
    }()
    
    /// 전체 컨텐츠를 포함한 스택 뷰
    private let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.contentStackSpacing
        stackView.alignment = .center
        
        return stackView
    }()
    
    /// 전체 컨텐츠 스크롤 뷰
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        
        return scrollView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup Functions
    
    /// 다이어리 객체를 받아와 각 뷰의 요소를 설정한다.
    /// - Parameter diary: 화면에 표시할 다이어리 객체
    func setupData(diary: Diary) {
        contentLabel.text = diary.content
        locationLabel.text = diary.location?.name
        
        let dateFormatter = Date.yearMonthDayTimeDateFormatter
        dateLabel.text = dateFormatter.string(from: diary.date ?? Date())
        activityIndicatorView.stopAnimating()
    }
    
    func setupNumberOfPages(_ count: Int) {
        imageSlider.setupNumberOfPages(count)
    }
    
    func setupCurrentPage(_ pageIndex: Int) {
        imageSlider.setupCurrentPage(pageIndex)
    }
    
    func setupImageSliderShowing(with isHidden: Bool) {
        imageSlider.isHidden = isHidden
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraint()
    }
    
    private func configureSubviews() {
        infoStack.addArrangedSubviews(locationLabel, dateLabel)
        contentStack.addArrangedSubviews(imageSlider, contentLabel, infoStack)
        
        scrollView.addSubview(contentStack)
        addSubviews(scrollView, activityIndicatorView)
    }
    
    private func configureConstraint() {
        imageSlider.snp.makeConstraints { $0.height.equalTo(imageSlider.snp.width) }
        [contentLabel, infoStack].forEach {
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(Metric.contentInsets)
            }
        }
        
        imageSlider.snp.makeConstraints { $0.horizontalEdges.equalToSuperview() }
        contentStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        activityIndicatorView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
}

// MARK: - Namespaces

extension DiaryDetailView {
    enum Metric {
        static let contentNumberOfLines = 0
        
        static let infoStackSpacing: CGFloat = 8
        static let contentStackSpacing: CGFloat = 16
        
        static let contentInsets: CGFloat = 16
    }
}
