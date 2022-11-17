//
//  EmptyLabeledCollectionView.swift
//  Doesaegim
//
//  Created by sun on 2022/11/15.
//

import UIKit

import SnapKit

/// 셀이 없는 경우 별도의 레이블을 띄우는 컬렉션 뷰
final class EmptyLabeledCollectionView: UICollectionView {

    // MARK: - UI Properties

    /// 셀이 없는 경우 나타나는 레이블
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(FontSize.body)
        label.textColor = .grey1

        return label
    }()


    // MARK: - Properties

    /// 셀이 있는지 여부
    var isEmpty: Bool = true {
        didSet {
            emptyLabel.isHidden = !isEmpty
        }
    }


    // MARK: - Init(s)

    convenience init(
        emptyLabelText: String,
        frame: CGRect = .zero,
        collectionViewLayout layout: UICollectionViewLayout = .init()
    ) {
        self.init(frame: frame, collectionViewLayout: layout)
        emptyLabel.text = emptyLabelText
    }

    private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

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
        addSubview(emptyLabel)
    }

    private func configureConstraints() {
        emptyLabel.snp.makeConstraints { $0.center.equalTo(safeAreaLayoutGuide) }
    }
}
