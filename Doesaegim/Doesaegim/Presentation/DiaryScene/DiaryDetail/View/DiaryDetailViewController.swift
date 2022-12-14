//
//  DiaryDetailViewController.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DetailImageCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DetailImageCellViewModel>
    typealias CellRegistration = UICollectionView
                                    .CellRegistration<DetailImageCell, DetailImageCellViewModel>
    
    // MARK: - UI Properties
    
    private let rootView = DiaryDetailView()
    
    // MARK: - Properties
    
    private let viewModel: DiaryDetailViewModel!
    
    private var imageSliderDataSource: DataSource?
    
    // MARK: - Init
    
    init(id: UUID) {
        let viewModel = DiaryDetailViewModel(id: id)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(diary: Diary) {
        let viewModel = DiaryDetailViewModel(diary: diary)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(viewModel: DiaryDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard isInitializedViewModel() else {
            presentErrorAlert(title: "다이어리 정보를 찾을 수 없습니다.", handler: { [weak self] _ in
                self?.viewModelDidNotInitialized()
            })
            return
        }
        
        bindToViewModel()
        configureImageSlider()
    }
    
    // MARK: - Configure Functions
    
    private func isInitializedViewModel() -> Bool {
        return viewModel != nil
    }
    
    /// 뷰모델이 이니셜라이징 되지 않았을 경우 해당 뷰를 pop 또는 dismiss 처리한다.
    private func viewModelDidNotInitialized() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
            return
        }
        dismiss(animated: true)
    }
    
    private func bindToViewModel() {
        viewModel.delegate = self
        viewModel.fetchDiaryDetail()
    }

    private func configureNavigationBar() {
        navigationItem.backButtonTitle = .empty
        let editButton = UIBarButtonItem(
            image: .edit,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let diary = self?.viewModel.diary,
                      let size = self?.view.bounds.size,
                      let scale = self?.view.window?.windowScene?.screen.scale,
                      let images = self?.viewModel.cellViewModels.map({ UIImage(
                        data: $0.data,
                        size: size,
                        scale: scale
                      )})
                else {
                    return
                }

                let editViewModel = DiaryEditViewModel(
                    diary: diary,
                    repository: DiaryEditLocalRepository(),
                    imageManager: ImageManager(),
                    images: images
                )
                let editViewController = DiaryEditViewController(viewModel: editViewModel)
                self?.show(editViewController, sender: self)
            }))
        
        let deleteButton = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let diary = self?.viewModel.diary,
                      let id = diary.id else { return }
                // 알림
                
                let cancelAction = UIAlertAction(title: "취소", style: .default)
                let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                    self?.viewModel.deleteDiary(with: id)
                }
                self?.presentAlert(
                    title: "다이어리를 삭제하시겠습니까?",
                    message: "삭제된 다이어리를 다시 복구할 수 없습니다.",
                    actions: cancelAction, deleteAction
                )
                
            })
        )
//        navigationItem.setRightBarButton(editButton, animated: true)
        navigationItem.setRightBarButtonItems([deleteButton, editButton], animated: true)
    }
    
    // MARK: - Configure ImageSlider Delegates
    
    private func configureImageSlider() {
        configureImageSliderDataSource()
        configureImageSliderDelegates()
        configureSnapshot()
    }
    
    /// 이미지 슬라이더 컬렉션뷰의 데이터소스를 지정한다.
    private func configureImageSliderDataSource() {
        let cellRegistration = CellRegistration { [weak self] cell, _, itemIdentifier in
            guard let size = self?.view.bounds.size,
                  let scale = self?.view.window?.windowScene?.screen.scale
            else {
                cell.setupImage(image: UIImage(data: itemIdentifier.data))
                return 
            }

            let image = UIImage(data: itemIdentifier.data, size: size, scale: scale)
            cell.setupImage(image: image)
        }
        
        imageSliderDataSource = DataSource(
            collectionView: rootView.imageSlider.slider
        ) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
            
            return cell
        }
    }
    
    /// 이미지 슬라이더 컬렉션뷰의 델리게이트를 지정한다.
    private func configureImageSliderDelegates() {
        rootView.imageSlider.delegate = self
        rootView.imageSlider.dataSource = imageSliderDataSource
    }
    
    /// 이미지 슬라이더 컬렉션뷰의 스냅샷을 지정한다.
    private func configureSnapshot() {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.cellViewModels)
        
        imageSliderDataSource?.apply(snapshot)
        rootView.setupImageSliderShowing(with: viewModel.cellViewModels.isEmpty)
    }
}

// MARK: - DiaryDetailViewModelDelegate

extension DiaryDetailViewController: DiaryDetailViewModelDelegate {
    
    func diaryDetailDidFetch(diary: Diary) {
        rootView.setupData(diary: diary)
    }
    
    func diaryDetailImageSliderPagesDidFetch(_ count: Int) {
        rootView.setupNumberOfPages(count)
    }
    
    func diaryDetailImageSliderDidRefresh() {
        configureSnapshot()
    }
    
    func diaryDeleteDidComplete() {
        navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - UICollectionView

extension DiaryDetailViewController {
    enum Section { case main }
}

extension DiaryDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageSliderDataSource,
              let item = imageSliderDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let photoDetailViewController = DiaryPhotoDetailViewController(imageData: item.data)
        navigationController?.pushViewController(photoDetailViewController, animated: true)
    }
}
