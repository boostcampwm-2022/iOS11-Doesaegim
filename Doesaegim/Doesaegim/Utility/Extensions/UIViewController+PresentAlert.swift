//
//  UIViewController+ShowAlert.swift
//  Doesaegim
//
//  Created by sun on 2022/11/16.
//

import UIKit

extension UIViewController {

    /// 확인 버튼만 갖고 있는 에러 알럿을 띄움
    func presentErrorAlert(
        title: String?,
        message: String? = nil,
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "확인", style: .default, handler: handler))
        present(alertController, animated: true)
    }
    
    /// 여러 액션들이 있는 얼럿
    func presentAlert(title: String,
                      message: String? = nil,
                      preferredStyle style: UIAlertController.Style = .alert,
                      actions: UIAlertAction...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        self.present(alert, animated: true)
    }
}
