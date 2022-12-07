//
//  ProgressiveImageView.swift
//  Doesaegim
//
//  Created by sun on 2022/11/24.
//

import UIKit

import SnapKit

final class ProgressiveImageView: UIImageView {

    // MARK: - UI Properties

    // TODO: 보경님한테 물어보고 사용하시기 편하게 Activity Indicator로 변경하기?
    let progressView = UIProgressView()


    // MARK: - Init(s)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
    }

    override init(image: UIImage?) {
        super.init(image: image)

        configureViews()
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)

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
        addSubview(progressView)
    }

    private func configureConstraints() {
        progressView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(Metric.progressiveViewCenterYOffset)
            $0.width.equalTo(Metric.progressiveViewWidth)
        }
    }
}


// MARK: - Constants
fileprivate extension ProgressiveImageView {

    enum Metric {
        static let progressiveViewWidth: CGFloat = 100

        static let progressiveViewCenterYOffset: CGFloat = 30
    }
}
