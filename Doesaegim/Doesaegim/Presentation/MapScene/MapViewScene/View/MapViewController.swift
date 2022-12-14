//
//  MapViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit
import MapKit


final class MapViewController: UIViewController {
    
    private var mapView: MKMapView?
    private let coordinate = CLLocationCoordinate2D(latitude: 40.728, longitude: -74)
    let viewModel: MapViewModelProtocol = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMap()
        configureSubviews()
        configureAnnotationView()
        viewModel.fetchDiary()
        configureLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapView?.delegate = nil
        mapView?.removeFromSuperview()
        mapView = nil
    }
    
    // MARK: - Configuration
    
    private func configureSubviews() {
        
        guard let mapView = mapView else { return }
        view.addSubview(mapView)
    }
    
    private func configureMap() {
        
        mapView = MKMapView()
        mapView?.frame = view.bounds
        mapView?.delegate = self
        
    }
    
    private func configureLocation() {
        let diaryInfos = viewModel.diaryInfos
        
        if diaryInfos.isEmpty {
            centerMapOnJongRo()
        } else {
            configureMapCenter()
        }
    }
    
    private func configureMapCenter() {
        guard let mapView = mapView,
              let latestDiary = viewModel.diaryInfos.first else { return }
        
        let latitude = latestDiary.latitude
        let longitude = latestDiary.longitude
        
        let centerCoordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        let region = MKCoordinateRegion(
            center: centerCoordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1
            )
        )
        
        mapView.setRegion(region, animated: true)
    }
    
    private func centerMapOnJongRo() {
        guard let mapView = mapView else { return }
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
        guard let mapView = mapView else { return }
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: NSStringFromClass(DiaryAnnotation.self)
        )
    }
    
    
    // MARK: - Functions
    
    private func clearAnnotation() {
        guard let mapView = mapView else { return }
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    private func addPin(with diaryInfo: DiaryMapInfoViewModel) {
        
        guard let mapView = mapView else { return }
        let latitude = diaryInfo.latitude
        let longitude = diaryInfo.longitude
        let coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let pin = DiaryAnnotation(coordinate: coordinate)
        pin.configure(with: diaryInfo)
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
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        if let annotation = view.annotation, annotation.isKind(of: DiaryAnnotation.self) {
            guard let annotation = annotation as? DiaryAnnotation,
                  let id = annotation.id else { return }
        
            let diaryViewController = DiaryDetailViewController(id: id)
            diaryViewController.modalPresentationStyle = .popover
            let presentationController =  diaryViewController.popoverPresentationController
            presentationController?.permittedArrowDirections = .any

            presentationController?.sourceRect = control.frame
            presentationController?.sourceView = control

            present(diaryViewController, animated: true, completion: nil)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? DiaryAnnotation {
            annotationView = setupDiaryAnnotationView(for: annotation, on: mapView)
        }
        
        return annotationView
    }
    
    private func setupDiaryAnnotationView(for annotation: DiaryAnnotation,
                                          on mapView: MKMapView) -> MKAnnotationView {
        
        let identifier = NSStringFromClass(DiaryAnnotation.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.markerTintColor = .primaryOrange
            
            if !annotation.imageData.isEmpty,
               let thumbnailImageData = annotation.imageData.first {
                // 사진이 없으면 아무 이미지도 없이 제목과 내용미리보기가 나온다.
                let image = UIImage(data: thumbnailImageData)
                let imageView = DiaryCalloutView(frame: .zero, image: image)

                markerAnnotationView.detailCalloutAccessoryView = imageView
            }
            
            let rightButton = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButton

        }
        return view
    }

}
