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
        
        guard isInitializedViewModel() else {
            presentErrorAlert(title: "다이어리 정보를 찾을 수 없습니다.", handler: { [weak self] _ in
                // FIXME: 모달창으로 띄워진다면? 사라지지 않음...
                self?.navigationController?.popViewController(animated: true)
            })
            return
        }
        
        bindToViewModel()
        configureImageSlider()
    }
    
    // MARK: - Configure Functions
    
    private func isInitializedViewModel() -> Bool {
        guard viewModel != nil else { return false }
        return true
    }
    
    private func bindToViewModel() {
        viewModel.delegate = self
        viewModel.fetchDiaryDetail()
    }
    
    // MARK: - Configure ImageSlider Delegates
    
    private func configureImageSlider() {
        configureImageSliderDataSource()
        configureImageSliderDelegates()
        configureSnapshot()
    }
    
    /// 이미지 슬라이더 컬렉션뷰의 데이터소스를 지정한다.
    private func configureImageSliderDataSource() {
        let cellRegistration = CellRegistration { cell, _, itemIdentifier in
            let image = UIImage(data: itemIdentifier.data)
            cell.setupImage(image: image)
        }
        
        imageSliderDataSource = DataSource(
            collectionView: rootView.imageSlider
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
    }
}

// MARK: - DiaryDetailViewModelDelegate

extension DiaryDetailViewController: DiaryDetailViewModelDelegate {
    
    func diaryDetailTitleDidFetch(with title: String?) {
        navigationItem.title = title
    }
    
    func diaryDetailDidFetch(diary: Diary) {
        rootView.setupData(diary: diary)
    }
    
    func diaryDetailImageSliderPagesDidFetch(_ count: Int) {
        rootView.setupNumberOfPages(count)
    }
    
    func diaryDetailImageSliderDidRefresh() {
        configureSnapshot()
    }
    
}


// MARK: - UICollectionView

extension DiaryDetailViewController {
    enum Section { case main }
}

extension DiaryDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 이미지를 선택했을 때 이미지 상세 화면으로 이동하도록 구현
    }
}
