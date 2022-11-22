//
//  MapViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit
import MapKit


final class MapViewController: UIViewController {
    
    let mapView = MKMapView()
    let coordinate = CLLocationCoordinate2D(latitude: 40.728, longitude: -74)
    let viewModel: MapViewModelProtocol = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        configureMap()
        configureAnnotationView()
        
        viewModel.fetchDiary()
        
//        view.addSubview(map)
//        map.frame = view.bounds
//        map.delegate = self
//        map.setRegion(
//            MKCoordinateRegion(
//                center: coordinate,
//                span: MKCoordinateSpan(
//                    latitudeDelta: 0.1,
//                    longitudeDelta: 0.1
//                )),
//            animated: true
//        )
        addCustomPin()
    }
    
    // MARK: - Configuration
    
    private func configureSubviews() {
        view.addSubview(mapView)
    }
    
    private func configureMap() {
        mapView.frame = view.bounds
        
        let jongRoCoordinate = CLLocationCoordinate2D(
            latitude: 37.5700,
            longitude: 126.9796
        )
        let defaultRegion = MKCoordinateRegion(
            center: jongRoCoordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1
            )
        )
        mapView.setRegion(defaultRegion, animated: true)
    }
    
    private func configureAnnotationView() {
        print(#function)
    }
    
    
    // MARK: - Functions
    
    
    private func addCustomPin() {
//        let pin = MKPointAnnotation()
//        pin.coordinate = coordinate
//        pin.title = "우하하"
//        pin.subtitle = "다이어리내용내용"
//        map.addAnnotation(pin)
    }
    
    private func clearAnnotation() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    private func addPin(with diaryInfo: DiaryMapInfoViewModel) {
        let pin = MKPointAnnotation()
        
        let latitude = diaryInfo.latitude
        let longitude = diaryInfo.longitude
        let coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        let title = diaryInfo.title
        let content = diaryInfo.content
        
        pin.coordinate = coordinate
        pin.title = title
        pin.subtitle = content
        mapView.addAnnotation(pin)
    }
    
}


extension MapViewController: MapViewModelDelegate {
    func mapViewDairyInfoDidChage() {
        clearAnnotation() // 어노테이션 삭제
        viewModel.diaryInfos.forEach { diaryInfo in
            self.addPin(with: diaryInfo)
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
        
//        if let annotaation = annotation as? Diary
        
        
    }

}


