//
//  DiaryAddViewController.swift
//  Doesaegim
//
//  Created by sun on 2022/11/21.
//

import PhotosUI
import UIKit

final class DiaryAddViewController: UIViewController {
    typealias ImageID = String
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ImageID>

    // MARK: - Enums

    private enum Section {
        case main
    }

    // MARK: - UI Properties

    private lazy var rootView = DiaryAddView()


    // MARK: - Properties

    private let viewModel = DiaryAddViewModel(
        repository: DiaryAddLocalRepository(),
        imageManager: ImageManager()
    )

    private lazy var imageSliderDataSource = configureImageSliderDataSource()


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
        configureImageSlider()
        configureNameTextField()
        configureContentTextView()
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

    /// 이미지 슬라이더, 이미지 추가 버튼 관련 설정
    private func configureImageSlider() {
        let presentPhotoPicker = UIAction { _ in
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.filter = .images
            configuration.selectionLimit = Metric.numberOfMaximumPhotos

            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true)

        }
        rootView.addPhotoButton.addAction(presentPhotoPicker, for: .touchUpInside)
    }

    private func configureImageSliderDataSource() -> DataSource {
        let cellRegistration = UICollectionView
            .CellRegistration<ProgressiveImageCollectionViewCell, ImageID> { cell, _, id in
                let imageStatus = self.viewModel.image(withID: id)
                switch imageStatus {
                case .inProgress(let progress):
                    cell.progress = progress
                case .complete(let image):
                    cell.image = image
                }
        }
        let collectionView = self.rootView.imageSlider

        let dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        collectionView.dataSource = dataSource
        return dataSource
    }

    private func configureNameTextField() {
        let textField = rootView.titleTextField
        let action = UIAction { _ in self.viewModel.titleDidChange(to: textField.text) }
        textField.addAction(action, for: .editingChanged)
    }

    private func configureContentTextView() {
        rootView.contentTextView.delegate = self
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

    func diaryAddViewModlelValuesDidChange(_ diary: TemporaryDiary) {
        rootView.travelTextField.text = diary.travel?.name
        rootView.placeSearchButton.setTitle(diary.location?.name, for: .normal)
    }

    func diaryAddViewModelDidUpdateSelectedImageIDs(_ identifiers: [ImageID]) {
        rootView.pageControl.numberOfPages = identifiers.count
        applySnapshot(usingIDs: identifiers)
    }

    func diaryAddViewModelDidLoadImage(withId id: ImageID) {
        reloadItem(withID: id)
    }

    private func applySnapshot(usingIDs identifiers: [ImageID]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ImageID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(identifiers)
        imageSliderDataSource.apply(snapshot, animatingDifferences: true)
    }

    private func reloadItem(withID id: ImageID) {
        var snapshot = imageSliderDataSource.snapshot()
        snapshot.reloadItems([id])
        imageSliderDataSource.apply(snapshot, animatingDifferences: true)
    }
}


// MARK: - SearchingLocationViewControllerDelegate
extension DiaryAddViewController: SearchingLocationViewControllerDelegate {
    func searchingLocationViewController(didSelect location: LocationDTO) {
        viewModel.locationDidSelect(location)
    }
}


// MARK: - PHPickerViewControllerDelegate
extension DiaryAddViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        viewModel.imageDidSelect(results.map { ($0.assetIdentifier ?? UUID().uuidString, $0.itemProvider) })
    }
}


// MARK: - UITextViewDelegate
extension DiaryAddViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.contentDidChange(to: textView.text)
    }
}


// MARK: - Constants
fileprivate extension DiaryAddViewController {

    enum Metric {
        static let spacing: CGFloat = 16

        static let numberOfMaximumPhotos = 5
    }

    enum StringLiteral {
        static let navigationTitle = "작성 화면"
    }
}
