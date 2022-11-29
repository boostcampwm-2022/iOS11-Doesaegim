//
//  SettingViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit

final class SettingViewController: UIViewController {
    
    lazy var shareManager: ShareManager = ShareManager.shared
    
    private let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("버튼", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonTapped() {
        shareManager.instaStoryShare(sharedView: testView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        view.addSubviews(testView, shareButton)
        testView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        shareButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(testView.snp.bottom).offset(30)
            $0.width.height.equalTo(100)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
