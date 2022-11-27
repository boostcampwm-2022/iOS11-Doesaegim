//
//  UIViewController+SetRightBarPlusButton.swift
//  Doesaegim
//
//  Created by sun on 2022/11/16.
//

import UIKit

extension UIViewController {

    /// 누르면 항목을 추가할 수 있는 뷰를 띄우는 우측 내비게이션 바 버튼을 설정
    ///
    /// 제목은 없고 + 아이콘만 가짐
    /// - Parameter viewController: 추가 버튼을 누르면 띄울 뷰 컨트롤러
    func setRightBarAddButton(using viewControllerFactory: @escaping () -> UIViewController) {
        let addButton = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { _ in
            self.show(viewControllerFactory(), sender: self)
        }))
        addButton.tintColor = .black
        navigationItem.setRightBarButton(addButton, animated: true)
    }
}
