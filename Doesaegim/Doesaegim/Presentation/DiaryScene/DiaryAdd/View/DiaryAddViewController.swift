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

    private var selectedTravelPickerIndex = Int.zero


    // MARK: - Life Cycle

    override func loadView() {
        view = rootView
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        bindToViewModel()
        observeKeyBoardAppearance()
        configureTravelPickerToolbar()
        configureTravelPicker()
        configureDateButton()
        configurePlaceSearchButton()
        configureNameTextField()
        configureContentTextView()
        applySnapshot(usingIDs: [.empty])
    }


    // MARK: - Configuration Functions

    private func configureNavigationBar() {
        navigationItem.title = StringLiteral.navigationTitle

        let saveAction = UIAction { [weak self] _ in
            self?.rootView.isSaving = true
            self?.rootView.endEditing(true)
            self?.viewModel.saveButtonDidTap()
        }
        let saveButton = UIBarButtonItem(image: .basicCheckmark, primaryAction: saveAction)
        saveButton.tintColor = .systemOrange
        saveButton.isEnabled = false
        navigationItem.setRightBarButton(saveButton, animated: true)
    }

    private func bindToViewModel() {
        viewModel.delegate = self
    }

    private func configureTravelPickerToolbar() {
        let cancelButton = UIBarButtonItem(
            image: .xmark,
            primaryAction: UIAction { [weak self] _ in self?.rootView.endEditing(true) }
        )
        let spaceButton = UIBarButtonItem(systemItem: .flexibleSpace)
        let doneButton  = UIBarButtonItem(
            image: .basicCheckmark,
            primaryAction: UIAction { [weak self] _ in
                guard let selectedRow = self?.rootView.travelPicker.selectedRow(inComponent: .zero),
                      let travel = self?.viewModel.travelPickerDataSource.itemForRow(selectedRow)
                else {
                    return
                }

                self?.selectedTravelPickerIndex = selectedRow
                self?.viewModel.travelDidSelect(travel)
                self?.rootView.endEditing(true)
            }
        )
        rootView.travelPickerToolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    }

    private func configureTravelPicker() {
        rootView.travelPicker.delegate = self
        rootView.travelPicker.dataSource = viewModel.travelPickerDataSource

        let configureInitialSelection = UIAction { [weak self] _ in
            if let index = self?.selectedTravelPickerIndex,
               index != self?.rootView.travelPicker.selectedRow(inComponent: .zero) {
                self?.rootView.travelPicker.selectRow(index, inComponent: .zero, animated: false)
            }

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

        let clearLocation = UIAction { [weak self] _ in
            self?.viewModel.locationDidSelect(nil)
        }
        rootView.placeSearchButton.clearButton.addAction(clearLocation, for: .touchUpInside)
    }

    private func configureDateButton() {
        let presentCalendar = UIAction { [weak self] _ in
            guard let dateInterval = self?.viewModel.dateInterval
            else {
                return 
            }
            let calendarViewController = CalendarViewController(
                touchOption: .single,
                type: .dateAndTime,
                startDate: dateInterval.start,
                endDate: dateInterval.end
            )
            calendarViewController.delegate = self
            self?.rootView.endEditing(true)
            self?.present(calendarViewController, animated: true)
        }
        rootView.dateInputButton.addAction(presentCalendar, for: .touchUpInside)
    }

    /// 사진 피커를 띄우는 액션
    private func presentPhotoPickerAction() -> UIAction {
        UIAction { [weak self] _ in
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.filter = .images

            let numberOfSelectedPhotos = self?.viewModel.selectedImageIDs.count ?? .zero
            let selectionLimit = Metric.numberOfMaximumPhotos - numberOfSelectedPhotos

            guard selectionLimit > .zero
            else {
                self?.presentErrorAlert(title: StringLiteral.disablePhotoSelection)
                return
            }
            configuration.selectionLimit = selectionLimit

            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self?.present(picker, animated: true)
        }
    }

    private func configureImageSliderDataSource() -> DataSource {
        let cellRegistration = UICollectionView
            .CellRegistration<ProgressiveImageCollectionViewCell, ImageID> { [weak self] cell, _, id in
                guard let imageStatus = self?.viewModel.image(withID: id)
                else {
                    return
                }
                
                cell.addPhotoButtonAction = self?.presentPhotoPickerAction()
                cell.removePhotoButtonAction = UIAction { [weak self] _ in
                    self?.viewModel.removeImage(withID: id)
                }
                switch imageStatus {
                case .inProgress(let progress):
                    cell.progress = progress
                case .complete(let image), .error(let image) :
                    cell.image = image
                case .dummy:
                    break
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

    private func applySnapshot(usingIDs identifiers: [ImageID]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ImageID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(identifiers)
        imageSliderDataSource.apply(snapshot, animatingDifferences: true)
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
}


// MARK: - DiaryAddViewModelDelegate
extension DiaryAddViewController: DiaryAddViewModelDelegate {

    func diaryAddViewModelValuesDidChange(_ diary: TemporaryDiary) {
        navigationItem.rightBarButtonItem?.isEnabled = diary.hasAllRequiredProperties
        rootView.travelTextField.text = diary.travel?.name
        rootView.placeSearchButton.setTitle(diary.location?.name, for: .normal)
        rootView.dateInputButton.setTitle(diary.dateString, for: .normal)
    }

    func diaryAddViewModelDidUpdateSelectedImageIDs(_ identifiers: [ImageID]) {
        rootView.imageSlider.setupNumberOfPages(identifiers.count)
        applySnapshot(usingIDs: identifiers)
    }

    func diaryAddViewModelDidLoadImage(withID id: ImageID) {
        var snapshot = imageSliderDataSource.snapshot()
        snapshot.reloadItems([id])
        imageSliderDataSource.apply(snapshot, animatingDifferences: true)
    }

    func diaryAddViewModelDidAddDiary(_ result: Result<Diary, Error>) {
        rootView.isSaving = false

        switch result {
        case .success:
            navigationController?.popViewController(animated: true)
        case .failure(let error):
            presentErrorAlert(
                title: CoreDataError.saveFailure(.diary).localizedDescription,
                message: error.localizedDescription
            )
        }
    }

    func diaryAddViewModelDidRemoveImage(withID id: ImageID) {
        var snapshot = imageSliderDataSource.snapshot()
        snapshot.deleteItems([id])
        if !snapshot.itemIdentifiers.contains(.empty) {
            snapshot.appendItems([.empty])
        }
        let slider = rootView.imageSlider
        slider.setupNumberOfPages(snapshot.itemIdentifiers.count)
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

        static let disablePhotoSelection = "사진은 5개만 추가 가능해요"
    }
}


// MARK: - CalendarViewDelegate
extension DiaryAddViewController: CalendarViewDelegate {
    func fetchDate(date: Date) {
        viewModel.dateDidSelect(date)
    }
}
