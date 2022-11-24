///
///  DiaryCalloutView.swift
///  Doesaegim
///
///  Created by Jaehoon So on 2022/11/23.
///
///
import UIKit


import SnapKit

final class DiaryCalloutView: UIImageView {

    // MARK: - Initializers

    convenience init(frame: CGRect, image: UIImage?) {
        self.init(frame: frame)
        
        self.image = image
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Configuration
    
    func configure() {
        contentMode = .scaleAspectFit
        configureConstraints()
    }

    func configureConstraints() {
        snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(150)
        }
    }
}
