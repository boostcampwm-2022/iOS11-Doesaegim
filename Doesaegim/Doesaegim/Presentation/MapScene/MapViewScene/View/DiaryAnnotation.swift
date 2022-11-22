//
//  DiaryAnnotation.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/22.
//

import UIKit
import MapKit


final class DiaryAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    var imageName: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}

extension DiaryAnnotation {
    func configure(with diaryInfo: DiaryMapInfoViewModel) {
        title = diaryInfo.title
        subtitle = diaryInfo.content // 내용을 나타낼찌, 날짜를 넣을지 추후 결정
    }
}
