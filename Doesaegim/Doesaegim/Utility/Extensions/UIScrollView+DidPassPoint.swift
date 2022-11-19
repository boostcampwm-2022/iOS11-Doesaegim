//
//  UIScrollView+DidPassPoint.swift
//  Doesaegim
//
//  Created by sun on 2022/11/17.
//

import UIKit

extension UIScrollView {

    /// 현재 스크롤 위치가 contentsize * 인자로 주어진 값을 곱한 높이를 초과하면 true, 아니면 false
    func didPassPoint(ofContentSizeRatio ratio: CGFloat = 0.8) -> Bool {
        let offsetY = contentOffset.y
        let targetPoint = (contentSize.height - frame.height) * ratio
        let didPassTarget = offsetY > targetPoint

        return didPassTarget
    }
}
