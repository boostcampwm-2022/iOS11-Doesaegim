//
//  ExpenseViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit

final class ExpenseTravelListController: UIViewController {

    // MARK: - Properties
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "일정 탭에서 새로운 여행을 추가해주세요!"
        label.textColor = .grey2
        
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        configureNavigationBar()
        configureSubviews()
        configureConstratins()
    }

    // MARK: - Configure
    
    func configureNavigationBar() {
        navigationItem.title = "여행 목록"
    }
    
    func configureSubviews() {
        view.addSubview(placeholderLabel)
    }
    
    func configureConstratins() {
        placeholderLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
        }
    }
    
    
}
