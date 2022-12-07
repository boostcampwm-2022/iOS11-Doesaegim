//
//  TranslucentActivityIndicatorView.swift
//  Doesaegim
//
//  Created by sun on 2022/11/28.
//

import UIKit

/// 회색의 반투명한 배경이 깔리는 UIActibituIndicatorView 
final class TranslucentActivityIndicatorView: UIView {

    // MARK: - Properties

    private let activityIndicator = UIActivityIndicatorView()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.alpha = Metric.alpha

        return view
    }()


    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        addTranslucentLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        addTranslucentLayer()
    }


    // MARK: - Configuration Functions

    private func addTranslucentLayer() {
        addSubviews(backgroundView, activityIndicator)

        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        activityIndicator.snp.makeConstraints { $0.edges.equalToSuperview() }
    }


    // MARK: - Activity Functions

    func startAnimating() {
        activityIndicator.startAnimating()
        isHidden = false
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}


// MARK: - Constants

fileprivate extension TranslucentActivityIndicatorView {

    enum Metric {
        static let alpha: CGFloat = 0.5
    }
}
