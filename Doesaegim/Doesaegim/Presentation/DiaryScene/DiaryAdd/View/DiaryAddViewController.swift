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

    private let viewModel = DiaryAddViewModel(repository: DiaryAddLocalRepository())


    // MARK: - Life Cycle

    override func loadView() {
        view = rootView
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        bindToViewModel()
        observeKeyBoardAppearance()
        configureTravelPicker()
        configurePlaceSearchButton()
    }


    // MARK: - Configuration Functions

    private func configureNavigationBar() {
        navigationItem.title = StringLiteral.navigationTitle
    }

    private func bindToViewModel() {
        viewModel.delegate = self
    }

    private func configureTravelPicker() {
        rootView.travelPicker.delegate = self
        rootView.travelPicker.dataSource = viewModel.travelPickerDataSource
    }

    private func configurePlaceSearchButton() {
        let action = UIAction { _ in
            self.rootView.endEditing(true)
            let controller = SearchingLocationViewController()
            controller.delegate = self
            self.show(controller, sender: self)
        }
        rootView.placeSearchButton.addAction(action, for: .touchUpInside)
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


// MARK: - UIPickerViewDelegate
extension DiaryAddViewController: UIPickerViewDelegate {
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        viewModel.travelPickerDataSource.itemForRow(row)?.name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let travel = viewModel.travelPickerDataSource.itemForRow(row)
        else {
            return
        }

        viewModel.travelDidSelect(travel)
    }
}


// MARK: - DiaryAddViewModelDelegate
extension DiaryAddViewController: DiaryAddViewModelDelegate {

    func diaryValuesDidChange(_ diary: TemporaryDiary) {
        rootView.travelTextField.text = diary.travel?.name
        rootView.placeSearchButton.setTitle(diary.location?.name, for: .normal)
    }
}


// MARK: - SearchingLocationViewControllerDelegate
extension DiaryAddViewController: SearchingLocationViewControllerDelegate {
    func searchingLocationViewController(didSelect location: LocationDTO) {
        viewModel.locationDidSelect(location)
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
