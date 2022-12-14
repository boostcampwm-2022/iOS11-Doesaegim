//
//  DateCollectionHeaderView.swift
//  Doesaegim
//
//  Created by sun on 2022/11/15.
//

import UIKit

import SnapKit

/// 날짜를 나타내는 컬렉션 헤더 뷰
final class DateCollectionHeaderView: UICollectionReusableView {

    // MARK: - UI Properties

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.changeFontSize(to: FontSize.title)

        return label
    }()


    // MARK: - Properties

    var dateString: String? = .empty {
        didSet {
            dateLabel.text = dateString
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
        addSubview(dateLabel)
    }

    private func configureConstraints() {
        dateLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
