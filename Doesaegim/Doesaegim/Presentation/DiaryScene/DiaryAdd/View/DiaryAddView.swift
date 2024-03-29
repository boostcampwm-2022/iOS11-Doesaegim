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

    let travelPickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = .primaryOrange
        toolbar.sizeToFit()

        return toolbar
    }()

    let travelPicker = UIPickerView()

    let travelTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = StringLiteral.travelTextFieldPlaceholder
        textField.font = textField.font?.withSize(FontSize.title)

        return textField
    }()

    let placeSearchButton = PlaceSearchButton()

    let dateInputButton: AddViewInputButton = {
        let button = AddViewInputButton()
        button.setTitle(StringLiteral.dateButtonPlaceholder, for: .normal)
        button.setImage(UIImage(systemName: StringLiteral.dateButtonImage), for: .normal)

        return button
    }()

    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = StringLiteral.titleTextFieldPlaceholder

        return textField
    }()

    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 8
        
        return textView
    }()

    private(set) lazy var imageSlider = ImageSliderView()

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

    private let activityIndicator: TranslucentActivityIndicatorView = {
        let view = TranslucentActivityIndicatorView()
        view.isHidden = true
        return view
    }()

    
    // MARK: - Properties

    var isSaving = true {
        didSet {
            if isSaving {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }


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
        addSubviews(scrollView, activityIndicator)
        scrollView.addSubview(contentStack)
        let contentStackSubviews = [
            travelTextField, placeSearchButton, dateInputButton,
            imageSlider,
            titleTextField, divider, contentTextView
        ]
        contentStack.addArrangedSubviews(contentStackSubviews)
        travelTextField.inputView = travelPicker
        travelTextField.inputAccessoryView = travelPickerToolbar
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
        [
            travelTextField, placeSearchButton, divider,
            dateInputButton, titleTextField, contentTextView
        ].forEach { view in
            view.snp.makeConstraints { $0.leading.trailing.equalToSuperview().inset(Metric.inset) }
        }
        [placeSearchButton, dateInputButton].forEach { view in
            view.snp.makeConstraints { $0.height.equalTo(Metric.placeSearchButtonHeight) }
        }
        imageSlider.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(imageSlider.snp.width)
        }
        divider.snp.makeConstraints { $0.height.equalTo(Metric.one)}
        activityIndicator.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}


// MARK: - Constants
fileprivate extension DiaryAddView {

    enum Metric {
        static let spacing: CGFloat = 8

        static let one: CGFloat = 1

        static let inset: CGFloat = 16

        static let cornerRadius: CGFloat = 8

        static let placeSearchButtonHeight: CGFloat = 37
    }

    enum StringLiteral {
        static let travelTextFieldPlaceholder = "여행을 선택해주세요"

        static let titleTextFieldPlaceholder = "제목"

        static let dateButtonPlaceholder = "여행을 먼저 선택해 주세요."

        static let dateButtonImage = "calendar"
    }
}
