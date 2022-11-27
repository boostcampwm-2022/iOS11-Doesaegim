//
//  TempDiaryViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/22.
//

import UIKit


import SnapKit

final class TempDiaryViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        
        label.text = "임시 다이어리 뷰 입니다~"
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        configureSubviews()
        configureConstraints()
    }

    
    func configureSubviews() {
        view.addSubview(label)
    }
    
    func configureConstraints() {
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
