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
        
        return view
    }()


    // MARK: - Properties

    var image: UIImage? {
        get { progressiveImageView.image }
        set {
            progressiveImageView.progressView.isHidden = true
            progressiveImageView.progressView.observedProgress = nil
            progressiveImageView.image = newValue
        }
    }

    var progress: Progress? {
        get { progressiveImageView.progressView.observedProgress }
        set {
            progressiveImageView.progressView.isHidden = false
            progressiveImageView.progressView.observedProgress = newValue
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

        image = nil
        progress = nil
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        configureSubviews()
        configureConstraints()
    }

    private func configureSubviews() {
        contentView.addSubview(progressiveImageView)
    }

    private func configureConstraints() {
        progressiveImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
