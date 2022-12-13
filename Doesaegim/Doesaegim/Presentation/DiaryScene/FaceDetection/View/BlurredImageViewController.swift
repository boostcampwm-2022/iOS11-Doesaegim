//
//  BlurredImageViewController.swift
//  Doesaegim
//
//  Created by sun on 2022/12/01.
//

import UIKit

import SnapKit

final class BlurredImageViewController: UIViewController {

    // MARK: - UI Properties

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()

    private let activityIndicator = UIActivityIndicatorView()


    // MARK: - Properties

    private let viewModel: BlurredImageViewModel


    // MARK: - Inits

    init(viewModel: BlurredImageViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        bindToViewModel()
        viewModel.applyFilter()
        configureNavigationBar()
    }


    // MARK: - Configuration Functions

    private func configureViews() {
        view.backgroundColor = .white
        configureSubviews()
    }

    private func configureSubviews() {
        view.addSubviews(imageView, activityIndicator)
        [imageView, activityIndicator].forEach { subview in
            subview.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        }
        activityIndicator.startAnimating()
    }

    private func bindToViewModel() {
        viewModel.blurCompletionHandler = { [weak self] in
            self?.imageView.image = $0
            self?.activityIndicator.stopAnimating()
        }
    }

    private func configureNavigationBar() {
        guard let image = imageView.image
        else {
            return
        }

        let shareButton = UIBarButtonItem(image: .init(systemName: StringLiteral.shareButtonImage))
        shareButton.tintColor = .systemOrange

        let sharedToActivityViewController = UIAction(
            title: StringLiteral.shareButtonTitle
        ) { [weak self] _ in
            guard let self
            else {
                return
            }

            ShareManager.shared.shareToActivityViewController(with: image, to: self)
        }
        let sharedToInstagramStory = UIAction(title: StringLiteral.instagramButtonTitle) { [weak self] _ in
            guard let self
            else {
                return
            }

            ShareManager.shared.shareToInstagramStory(with: image, to: self)
        }
        shareButton.menu = UIMenu(
            options: .displayInline,
            children: [sharedToActivityViewController, sharedToInstagramStory]
        )

        navigationItem.rightBarButtonItem = shareButton
    }
}


// MARK: - Constants

fileprivate extension BlurredImageViewController {

    enum StringLiteral {
        static let shareButtonImage = "square.and.arrow.up"

        static let shareButtonTitle = "공유하기"

        static let instagramButtonTitle = "인스타그램 스토리로 공유하기"
    }
}
