//
//  DiaryPhotoDetailViewController.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/30.
//

import UIKit

import SnapKit

final class DiaryPhotoDetailViewController: UIViewController {
    
    // MARK: - UI properties
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()
    
    // MARK: - Properties
    
    private let item: DetailImageCellViewModel
    
    // MARK: - Lifecycles
    
    init(item: DetailImageCellViewModel) {
        self.item = item
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configurePhotoImageView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        photoImageView.image = nil
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        view.backgroundColor = .white
        configureSubViews()
        configureConstraints()
        configureNavigationBar()
        configurePhotoImageView()
        
    }
    
    private func configureSubViews() {
        view.addSubview(photoImageView)
    }
    
    private func configureConstraints() {
        photoImageView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
    
    private func configureNavigationBar() {
        let shareButton = UIBarButtonItem(
            // TODO: 3개 점있는 이미지를 도저히 못찾겠습니다..;;
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: nil
        )
        
        let mosaicToShare = UIAction(
            title: "모자이크 후 공유하기") { [weak self] _ in
                guard let self,
                      let image = self.photoImageView.image else { return }
                let controller = FaceDetectController(image: image, viewModel: FaceDetectViewModel())
                self.navigationController?.pushViewController(controller, animated: true)
            }
        let sharedToActivityViewController = UIAction(
            title: "공유하기") { [weak self] _ in
                guard let self else { return }
                ShareManager.shared.shareToActivityViewController(with: self.photoImageView, to: self)
            }
        let sharedToInstagramStroy = UIAction(
            title: "인스타그램 스토리로 공유하기") { [weak self] _ in
                guard let self else { return }
                ShareManager.shared.shareToInstagramStory(with: self.photoImageView, to: self)
            }
        let cancel = UIAction(title: "취소", attributes: .destructive) { _ in }
        shareButton.menu = UIMenu(
            title: "공유하기",
            options: .displayInline,
            children: [mosaicToShare, sharedToActivityViewController, sharedToInstagramStroy, cancel]
        )
        
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func configurePhotoImageView() {
        photoImageView.image = UIImage(data: item.data)
    }
}
