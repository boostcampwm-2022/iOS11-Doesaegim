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
    var content: String?
    var imagePath: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
