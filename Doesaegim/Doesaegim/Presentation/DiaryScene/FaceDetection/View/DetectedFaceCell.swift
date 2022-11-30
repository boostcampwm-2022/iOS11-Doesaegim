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
    
    let opacityView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .grey4
        view.layer.opacity = 0.35
        
        return view
    }()
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .primaryOrange
        
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
        
        configureSubviews()
        configureView()
        configureConstraints()
    }
    
    private func configureView() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderColor = UIColor.primaryOrange?.cgColor
        layer.borderWidth = 0
        
        opacityView.isHidden = true
        checkmarkImageView.isHidden = true
        
    }
    
    private func configureSubviews() {
        addSubview(imageView)
        addSubview(opacityView)
        addSubview(checkmarkImageView)
    }
    
    private func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        opacityView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
    
    func configureInfo(with info: DetectInfoViewModel) {
        imageView.image = info.image
    }
    
    func setupCellStatus(with status: Bool) {
        switch status {
        case true:
            opacityView.isHidden = false
            checkmarkImageView.isHidden = false
            layer.borderWidth = 5
        case false:
            opacityView.isHidden = true
            checkmarkImageView.isHidden = true
            layer.borderWidth = 0
        }
    }
}
