//
//  FaceDetectViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/29.
//

import UIKit


struct DetectInfoViewModel: Hashable {
    
    var uuid: UUID
    var image: UIImage // 선택된 부분의 이미지
    var bound: CGRect
    var isSelected: Bool
    var downsampledBounds: CGRect
    
    init(uuid: UUID, image: UIImage, bound: CGRect, downsampledBounds: CGRect) {
        self.uuid = uuid
        self.image = image
        self.bound = bound
        self.isSelected = false
        self.downsampledBounds = downsampledBounds
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
}
