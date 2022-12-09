//
//  PlanCollectionViewCell.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//

import UIKit

import SnapKit

final class PlanCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties

    private let checkBox = CheckBox()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.changeFontSize(to: FontSize.body)
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping

        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.changeFontSize(to: FontSize.caption)
        label.textColor = .grey3
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.changeFontSize(to: FontSize.caption)
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.textColor = .grey3

        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.changeFontSize(to: FontSize.caption)
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.textColor = .grey3

        return label
    }()

    /// 체크박스와 모든 레이블을 담고 있는 최상위 스택 뷰
    private let contentStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Metric.contentStackSpacing

        return view
    }()

    /// 레이블들만 담고 있는 스택뷰
    private let labelStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Metric.spacing
        view.axis = .vertical

        return view
    }()

    private let nameAndTimeStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Metric.spacing

        return view
    }()


    // MARK: - Properties

    var viewModel: PlanViewModel? {
        didSet { render() }
    }

    var checkBoxAction: UIAction? {
        didSet {
            guard let action = checkBoxAction
            else {
                return
            }

            checkBox.addAction(action, for: .touchUpInside)
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


    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel = nil
        viewModel?.checkBoxToggleHandler = nil
        
        guard let action = checkBoxAction
        else {
            return
        }

        checkBox.removeAction(action, for: .touchUpInside)
    }


    // MARK: - Rendering Functions

    /// 뷰모델로부터 데이터를 받아와 그림, 뷰모델이 없는 경우 전부 nil로 초기화
    func render() {
        checkBox.isChecked = viewModel?.isComplete == true
        nameLabel.text = viewModel?.name
        timeLabel.text = viewModel?.timeString
        locationLabel.text = viewModel?.location
        contentLabel.text = viewModel?.content
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        configureSubviews()
        configureConstraints()
    }

    private func configureSubviews() {
        contentView.addSubview(contentStack)
        contentStack.addArrangedSubviews(checkBox, labelStack)
        labelStack.addArrangedSubviews(nameAndTimeStack, locationLabel, contentLabel)
        nameAndTimeStack.addArrangedSubviews(nameLabel, timeLabel)
    }

    private func configureConstraints() {
        contentStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(Metric.inset) }
    }
}


// MARK: - Constants
fileprivate extension PlanCollectionViewCell {

    enum Metric {

        static let spacing: CGFloat = 4

        static let contentStackSpacing: CGFloat = 8

        static let inset: CGFloat = 10

        static let checkBoxWidth: CGFloat = 30
    }
}
