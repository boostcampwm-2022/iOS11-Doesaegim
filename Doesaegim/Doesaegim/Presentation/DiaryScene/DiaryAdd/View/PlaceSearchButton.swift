//
//  PlaceSearchButton.swift
//  Doesaegim
//
//  Created by sun on 2022/11/21.
//

import UIKit

/// 장소 검색 화면으로 넘어가는 버튼
final class PlaceSearchButton: UIButton {

    // MARK: - UI Properties

    let clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: StringLiteral.clearButtonImageName), for: .normal)
        button.tintColor = UIColor.gray

        return button
    }()


    // MARK: - Init(s)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureViews()
    }


    // MARK: - Override Functions

    /// title이 nil인 경우 항상 placeholder text를 나타내기 위해 오버라이드
    override func setTitle(_ title: String?, for state: UIControl.State) {
        let newTitle = title == nil ? StringLiteral.placeholderText : title
        super.setTitle(newTitle, for: state)
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        layer.cornerRadius = Metric.cornerRadius
        backgroundColor = .grey1
        setTitleColor(.grey3, for: .normal)
        setTitle(StringLiteral.placeholderText, for: .normal)
        titleLabel?.changeFontSize(to: FontSize.body)
        setImage(.init(systemName: StringLiteral.imageName), for: .normal)
        titleEdgeInsets = Metric.titleEdgeInsets
        imageEdgeInsets = Metric.imageEdgeInsets
        tintColor = .grey3
        contentHorizontalAlignment = .left
        configureClearButton()
    }

    private func configureClearButton() {
        addSubview(clearButton)
        clearButton.snp.makeConstraints {
            $0.height.equalTo(snp.height)
            $0.width.equalTo(clearButton.snp.height)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}


// MARK: - Constants

fileprivate extension PlaceSearchButton {

    enum Metric {
        static let cornerRadius: CGFloat = 10

        static let titleEdgeInsets = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: -5)

        static let imageEdgeInsets = UIEdgeInsets(top: .zero, left: 5, bottom: .zero, right: 5)
    }

    enum StringLiteral {
        static let placeholderText = "장소를 검색해주세요"

        static let imageName = "magnifyingglass"

        static let clearButtonImageName = "xmark.circle.fill"
    }
}
