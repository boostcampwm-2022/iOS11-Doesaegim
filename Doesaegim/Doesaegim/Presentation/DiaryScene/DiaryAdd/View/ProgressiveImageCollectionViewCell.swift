//
//  ProgressiveImageCollectionViewCell.swift
//  Doesaegim
//
//  Created by sun on 2022/11/24.
//

import UIKit

import SnapKit

final class ProgressiveImageCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties

    private let progressiveImageView: ProgressiveImageView = {
        let view = ProgressiveImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.progressView.isHidden = true
        
        return view
    }()


    // MARK: - Properties

    var addPhotoButtonAction: UIAction? {
        didSet {
            if let oldValue {
                addPhotoButton.removeAction(oldValue, for: .touchUpInside)
            }
            if let addPhotoButtonAction {
                addPhotoButton.addAction(addPhotoButtonAction, for: .touchUpInside)
            }
        }
    }

    var removePhotoButtonAction: UIAction? {
        didSet {
            if let oldValue {
                removePhotoButton.removeAction(oldValue, for: .touchUpInside)
            }
            if let removePhotoButtonAction {
                removePhotoButton.addAction(removePhotoButtonAction, for: .touchUpInside)
            }
        }
    }

    private let addPhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.init(systemName: StringLiteral.squaredPlus), for: .normal)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: Metric.buttonWidth)
        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        button.tintColor = .primaryOrange

        return button
    }()

    private let removePhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.init(systemName: StringLiteral.squaredMinus), for: .normal)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: Metric.buttonWidth)
        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        button.tintColor = .primaryOrange
        button.isHidden = true

        return button
    }()

    var image: UIImage? {
        get { progressiveImageView.image }
        set {
            progressiveImageView.progressView.isHidden = true
            progressiveImageView.progressView.observedProgress = nil
            progressiveImageView.image = newValue
            removePhotoButton.isHidden = image == nil
            addPhotoButton.isHidden = image != nil
        }
    }

    var progress: Progress? {
        get { progressiveImageView.progressView.observedProgress }
        set {
            progressiveImageView.progressView.isHidden = false
            progressiveImageView.progressView.observedProgress = newValue

            if progress != nil {
                removePhotoButton.isHidden = true
                addPhotoButton.isHidden = true
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


    // MARK: - Life Cycel

    override func prepareForReuse() {
        super.prepareForReuse()

        progress = nil
        image = nil
        removePhotoButtonAction = nil
        addPhotoButtonAction = nil
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        configureSubviews()
        configureConstraints()
    }

    private func configureSubviews() {
        contentView.addSubviews(progressiveImageView, addPhotoButton, removePhotoButton)
    }

    private func configureConstraints() {
        progressiveImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        addPhotoButton.snp.makeConstraints { $0.center.equalToSuperview() }
        removePhotoButton.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}


// MARK: - Constants
fileprivate extension ProgressiveImageCollectionViewCell {

    enum Metric {
        static let buttonWidth: CGFloat = 36
    }

    enum StringLiteral {

        static let squaredPlus = "plus.square"

        static let squaredMinus = "minus.square"
    }
}
