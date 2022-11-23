//
//  DiaryAddViewController.swift
//  Doesaegim
//
//  Created by sun on 2022/11/21.
//

import UIKit

final class DiaryAddViewController: UIViewController {

    // MARK: - UI Properties

    private lazy var rootView = DiaryAddView()


    // MARK: - Properties



    // MARK: - Life Cycle

    override func loadView() {
        view = rootView
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        observeKeyBoardAppearance()
    }



    // MARK: - Configuration Functions

    private func configureNavigationBar() {
        navigationItem.title = StringLiteral.navigationTitle
    }


    // MARK: - Keyboard Appearance Observing Functions

    private func observeKeyBoardAppearance() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    /// 키보드가 나타나면 스크롤뷰 content inset을 조절해 가려지는 부분이 없도록 함
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }

        let contentInsets = UIEdgeInsets(
            top: .zero,
            left: .zero,
            bottom: keyboardSize.height - (tabBarController?.tabBar.frame.height ?? .zero) + Metric.spacing,
            right: .zero
        )
        rootView.scrollView.contentInset = contentInsets
        rootView.scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        rootView.scrollView.contentInset = .zero
        rootView.scrollView.scrollIndicatorInsets = .zero
    }
}


// MARK: - Constants

fileprivate extension DiaryAddViewController {

    enum Metric {
        static let spacing: CGFloat = 16
    }

    enum StringLiteral {
        static let navigationTitle = "작성 화면"
    }
}
