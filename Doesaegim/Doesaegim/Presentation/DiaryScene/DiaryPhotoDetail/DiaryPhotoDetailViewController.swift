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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Properties
    
    private let item: DetailImageCellViewModel
    
    // MARK: - Lifecycles
    
    init(item: DetailImageCellViewModel) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
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
        photoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(photoImageView.snp.width)
        }
    }
    
    private func configureNavigationBar() {
        let shareButton = UIBarButtonItem(
            // TODO: 3개 점있는 이미지를 도저히 못찾겠습니다..;;
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(didTapShareButton)
        )
        navigationItem.rightBarButtonItem = shareButton
    }
    
    private func configurePhotoImageView() {
        photoImageView.image = UIImage(data: item.data)
    }
    
    // MARK: - Action
    
    @objc func didTapShareButton() {
        print("공유버튼 클릭")
    }
}
