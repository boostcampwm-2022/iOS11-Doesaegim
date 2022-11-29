//
//  DetectedFaceCell.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/29.
//

import UIKit

final class DetectedFaceCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier: String = NSStringFromClass(DetectedFaceCell.self)
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension DetectedFaceCell {
    
    private func configure() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        addSubview(imageView)
    }
    
    private func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    func configureInfo(with info: DetectInfoViewModel) {
        imageView.image = info.image
    }
}
