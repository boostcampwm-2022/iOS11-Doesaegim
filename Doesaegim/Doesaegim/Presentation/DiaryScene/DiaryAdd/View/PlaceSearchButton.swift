//
//  PlaceSearchButton.swift
//  Doesaegim
//
//  Created by sun on 2022/11/21.
//

import UIKit

/// 장소 검색 화면으로 넘어가는 버튼
final class PlaceSearchButton: UIButton {

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
        layer.cornerRadius = Metric.cornerRadius
        backgroundColor = .grey1
        setTitleColor(.grey3, for: .normal)
        setTitle(StringLiteral.title, for: .normal)
        titleLabel?.changeFontSize(to: FontSize.body)
        setImage(.init(systemName: StringLiteral.imageName), for: .normal)
        titleEdgeInsets = Metric.titleEdgeInsets
        imageEdgeInsets = Metric.imageEdgeInsets
        tintColor = .grey3
        contentHorizontalAlignment = .left
    }
}


// MARK: - Constants

fileprivate extension PlaceSearchButton {

    enum Metric {
        static let cornerRadius: CGFloat = 10

        static let titleEdgeInsets = UIEdgeInsets(top: .zero, left: 15, bottom: .zero, right: -5)

        static let imageEdgeInsets = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: 5)
    }

    enum StringLiteral {
        static let title = "장소를 검색해주세요"

        static let imageName = "magnifyingglass"
    }
}
