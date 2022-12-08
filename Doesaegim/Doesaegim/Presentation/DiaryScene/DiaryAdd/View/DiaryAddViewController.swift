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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }


    // MARK: - Configuration Functions

    private func configureNavigationBar() {
        navigationItem.title = StringLiteral.navigationTitle

        let saveAction = UIAction { [weak self] _ in
            self?.rootView.isSaving = true
            self?.rootView.endEditing(true)
            self?.viewModel.saveButtonDidTap()
        }
        let saveButtonImage = UIImage(systemName: StringLiteral.saveButtonImageName)
        let saveButton = UIBarButtonItem(image: saveButtonImage, primaryAction: saveAction)
        saveButton.tintColor = .systemOrange
        saveButton.isEnabled = false
        navigationItem.setRightBarButton(saveButton, animated: true)
    }

    private func bindToViewModel() {
        viewModel.delegate = self
    }

    private func configureTravelPicker() {
        rootView.travelPicker.delegate = self
        rootView.travelPicker.dataSource = viewModel.travelPickerDataSource

        let configureInitialSelection = UIAction { [weak self] _ in
            guard self?.rootView.travelTextField.hasText != true,
                  let travel = self?.viewModel.travelPickerDataSource.itemForRow(.zero)
            else {
                return
            }
            self?.viewModel.travelDidSelect(travel)
        }
        rootView.travelTextField.addAction(configureInitialSelection, for: .editingDidBegin)
    }

    private func configurePlaceSearchButton() {
        let showLocationViewController = UIAction { [weak self] _ in
            self?.rootView.endEditing(true)
            let controller = SearchingLocationViewController()
            controller.delegate = self
            self?.show(controller, sender: self)
        }
        rootView.placeSearchButton.addAction(showLocationViewController, for: .touchUpInside)
    }

    /// 이미지 슬라이더, 이미지 추가 버튼 관련 설정
    private func configureImageSlider() {
        let presentPhotoPicker = UIAction { [weak self] _ in
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.filter = .images
            configuration.selectionLimit = Metric.numberOfMaximumPhotos

            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self?.present(picker, animated: true)

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
                case .complete(let image), .error(let image) :
                    cell.image = image
                }
        }
        let collectionView = self.rootView.imageSlider.slider

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
        let action = UIAction { [weak self] _ in self?.viewModel.titleDidChange(to: textField.text) }
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
        let tabBar = tabBarController?.tabBar
        let tabBarIsShowing = tabBar?.isHidden == false
        let tabBarHeight = tabBar?.frame.height ?? .zero
        let safeAreaBottomInset = tabBarIsShowing ? tabBarHeight : view.safeAreaInsets.bottom

        let contentInsets = UIEdgeInsets(
            top: .zero,
            left: .zero,
            bottom: keyboardSize.height - safeAreaBottomInset + Metric.spacing,
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
// TODO: 종료 날짜순으로 정렬해서 호출하고, 초기값 설정하기?
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
        navigationItem.rightBarButtonItem?.isEnabled = diary.hasAllRequiredProperties
        rootView.travelTextField.text = diary.travel?.name
        rootView.placeSearchButton.setTitle(diary.location?.name, for: .normal)
    }

    func diaryAddViewModelDidUpdateSelectedImageIDs(_ identifiers: [ImageID]) {
        rootView.imageSlider.setupNumberOfPages(identifiers.count)
        applySnapshot(usingIDs: identifiers)
    }

    func diaryAddViewModelDidLoadImage(withId id: ImageID) {
        reloadItem(withID: id)
    }

    func diaryAddViewModelDidAddDiary(_ result: Result<Diary, Error>) {
        rootView.isSaving = false

        switch result {
        case .success(let diary):
            navigationController?.popViewController(animated: true)
        case .failure(let error):
            presentErrorAlert(
                title: CoreDataError.saveFailure(.diary).localizedDescription,
                message: error.localizedDescription
            )
        }
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

        static let saveButtonImageName = "checkmark"
    }
}
