//
//  DiaryDetailViewController.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/23.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    // MARK: - UI Properties
    
    private let rootView = DiaryDetailView()
    
    // MARK: - Properties
    
    private let viewModel: DiaryDetailViewModel
    
    // MARK: - Init
    
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
        
        configureViewModelDelegate()
        configureCollectionViewDelegate()
    }
    
    // MARK: - Configure Functions
    
    private func configureViewModelDelegate() {
        viewModel.delegate = self
        viewModel.fetchDiaryDetail()
    }
    
    private func configureCollectionViewDelegate() {
        rootView.imageSlider.register(
            DiaryDetailImageCell.self,
            forCellWithReuseIdentifier: "DiaryDetailImageCell"
        )
        
        rootView.imageSlider.delegate = self
        rootView.imageSlider.dataSource = self
    }
}

// MARK: - DiaryDetailViewModelDelegate

extension DiaryDetailViewController: DiaryDetailViewModelDelegate {
    
    func fetchNavigationTItle(with title: String?) {
        navigationItem.title = title
    }
    
    func fetchDiaryDetail(diary: Diary) {
        rootView.setupData(diary: diary)
    }
    
    func fetchImageData(with items: [Data]) {
        rootView.setupImages(with: items)
    }
    
    func pageControlValueDidChange(to page: Int) {
        rootView.setupCurrentPage(page)
    }
}


// MARK: - UICollectionView

extension DiaryDetailViewController {
    
    /// 스크롤 될 때마다 현재 페이지의 위치를 계산해서 PageControl의 현재 페이지를 변경한다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let currentPageIndex = Int(scrollView.contentOffset.x / width)
        
        viewModel.currentPageDidChange(to: currentPageIndex)
    }
}

extension DiaryDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 이미지를 선택했을 때 이미지 상세 화면으로 이동하도록 구현
    }
}

extension DiaryDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "DiaryDetailImageCell",
            for: indexPath
        ) as? DiaryDetailImageCell else { return UICollectionViewCell() }
        
        cell.setupImage(image: UIImage(systemName: "heart.fill"))
        
        return cell
    }
    
    
}
