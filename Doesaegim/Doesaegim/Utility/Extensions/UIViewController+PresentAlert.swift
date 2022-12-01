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
    
    /// 작성중이고, 뒤로가기 버튼을 눌렀을 때, 얼럿을 띄움
    func presentIsClearAlert() {
        let okAction = UIAlertAction(title: "뒤로가기", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "작성", style: .cancel)
        presentAlert(
            title: "취소",
            message: "현재 작성된 정보가 사라집니다.\n계속 하시겠습니까?",
            actions: okAction, cancelAction
        )
    }
}
