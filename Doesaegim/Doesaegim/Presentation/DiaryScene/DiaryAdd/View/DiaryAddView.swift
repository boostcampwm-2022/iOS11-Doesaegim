//
//  DiaryAddView.swift
//  Doesaegim
//
//  Created by sun on 2022/11/21.
//

import UIKit

import SnapKit

final class DiaryAddView: UIView {

    // MARK: - UI Properties

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false

        return scrollView
    }()

    let travelPicker = UIPickerView()

    let travelTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = StringLiteral.travelTextFieldPlaceholder
        textField.font = textField.font?.withSize(FontSize.title)

        return textField
    }()

    let placeSearchButton = PlaceSearchButton()

    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = StringLiteral.titleTextFieldPlaceholder

        return textField
    }()

    private let addPhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.init(systemName: StringLiteral.squaredPlus), for: .normal)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: Metric.addPhotoButtonWidth)
        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        button.tintColor = .primaryOrange

        return button
    }()

    private let imageSlider: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Metric.one),
            heightDimension: .fractionalHeight(Metric.one)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Metric.one),
            heightDimension: .fractionalHeight(Metric.one)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        let layout = UICollectionViewCompositionalLayout(section: section)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .grey1
        control.currentPageIndicatorTintColor = .primaryOrange

        return control
    }()

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 8

        return textView
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .grey1

        return view
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Metric.spacing
        stack.alignment = .center

        return stack
    }()

    
    // MARK: - Properties


    // MARK: - Init(s)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureViews()
    }



    // MARK: - Configuration Functions

    private func configureViews() {
        configureSubviews()
        configureConstraints()
    }

    private func configureSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentStack)
        let contentStackSubviews = [
            travelTextField, placeSearchButton,
            imageSlider, pageControl,
            titleTextField, divider, contentTextView
        ]
        contentStack.addArrangedSubviews(contentStackSubviews)
        travelTextField.inputView = travelPicker
        imageSlider.addSubview(addPhotoButton)
        scrollView.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(backgroundDidTap)
        ))
    }

    /// 키보드, 피커 등 올라온 뷰를 내림
    @objc private func backgroundDidTap() {
        endEditing(true)
    }

    private func configureConstraints() {
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentStack.snp.makeConstraints { $0.edges.width.equalToSuperview() }
        [travelTextField, placeSearchButton, divider, titleTextField, contentTextView].forEach { view in
            view.snp.makeConstraints { $0.leading.trailing.equalToSuperview().inset(Metric.inset) }
        }
        placeSearchButton.snp.makeConstraints { $0.height.equalTo(Metric.placeSearchButtonHeight) }
        imageSlider.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(imageSlider.snp.width)
        }
        divider.snp.makeConstraints { $0.height.equalTo(Metric.one)}
        addPhotoButton.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}


// MARK: - Constants
fileprivate extension DiaryAddView {

    enum Metric {
        static let spacing: CGFloat = 8

        static let addPhotoButtonWidth: CGFloat = 36

        static let one: CGFloat = 1

        static let inset: CGFloat = 16

        static let cornerRadius: CGFloat = 8

        static let placeSearchButtonHeight: CGFloat = 37
    }

    enum StringLiteral {
        static let travelTextFieldPlaceholder = "여행을 선택해주세요"

        static let squaredPlus = "plus.app"

        static let titleTextFieldPlaceholder = "제목"
    }
}
