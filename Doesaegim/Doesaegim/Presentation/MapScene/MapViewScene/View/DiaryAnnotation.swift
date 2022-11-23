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
    
    var id: UUID?
    var title: String?
    var subtitle: String?
    var imageData: [Data] = []
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}

extension DiaryAnnotation {
    func configure(with diaryInfo: DiaryMapInfoViewModel) {
        id = diaryInfo.id
        title = diaryInfo.title
        subtitle = diaryInfo.content // 내용을 나타낼찌, 날짜를 넣을지 추후 결정
        
//        guard let imagePaths = diaryInfo.imagePaths else { return }
//        imagePath = imagePaths.first
    }
}
