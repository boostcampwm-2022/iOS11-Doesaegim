//
//  TravelPlanViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit
import SnapKit

final class TravelPlanViewController: UIViewController {

    
    let placeholdLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 여행을 떠나볼까요?"
        label.textColor = .grey2
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        configureSubviews()
        configureConstraints()
    }
    
    // MARK: - Configure
    
    func configureSubviews() {
        view.addSubview(placeholdLabel)
    }
    
    func configureConstraints() {
        placeholdLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
        }
    }
    

}
