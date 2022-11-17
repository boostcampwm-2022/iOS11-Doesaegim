//
//  UIViewController+ShowAlert.swift
//  Doesaegim
//
//  Created by sun on 2022/11/16.
//

import UIKit

extension UIViewController {

    /// 확인 버튼만 갖고 있는 에러 알럿을 띄움
    func presentErrorAlert(title: String?, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "확인", style: .default))
        present(alertController, animated: true)
    }
}
