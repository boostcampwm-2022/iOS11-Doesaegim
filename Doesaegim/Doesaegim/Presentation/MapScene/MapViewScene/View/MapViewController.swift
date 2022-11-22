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
        addDummyPins() // 더미 핀을 추가하고 싶을 때
        
        viewModel.fetchDiary()
        
    }
    
    // 추후 지워질 함 수 더미 핀을 만드는 함수
    private func addDummyPins() {
        print(#function)
        let diaryInfoViewModel = DiaryMapInfoViewModel(
            id: UUID(),
            imagePaths: nil,
            title: "제목입니다.",
            content: "콘텐츠 입니다",
            date: Date(),
            latitude: 37.57,
            longitude: 126.9796
        )
        addPin(with: diaryInfoViewModel)
    }
    
    // MARK: - Configuration
    
    private func configureSubviews() {
        view.addSubview(mapView)
    }
    
    private func configureMap() {
        mapView.frame = view.bounds
        mapView.delegate = self
        centerMapOnJongRo()
        
    }
    
    private func centerMapOnJongRo() {
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
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: NSStringFromClass(DiaryAnnotation.self)
        )
    }
    
    
    // MARK: - Functions
    
    private func clearAnnotation() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    private func addPin(with diaryInfo: DiaryMapInfoViewModel) {
        
        let latitude = diaryInfo.latitude
        let longitude = diaryInfo.longitude
        let coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let pin = DiaryAnnotation(coordinate: coordinate)
        pin.configure(with: diaryInfo)
        // TODO: - 이미지 경로 이곳에서 설정하고 mapView(annotation:mapView) 메서드에서 경로로 이미지받아와서 붙인다.
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
            print("다이어리 어노테이션을 탭 했습니다.")
            
            let diaryViewController =  TempDiaryViewController()
//            navigationController?.pushViewController(diaryViewController, animated: true)
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
        
        print(type(of: annotation))
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
            
            // TODO: - 이미지 넣는 방식 결정
//            let image = UIImage(systemName: "photo")
//            markerAnnotationView.detailCalloutAccessoryView = UIImageView(image: image)
            let thumbnailImageView: UIImageView = UIImageView(image: UIImage(systemName: "photo"))
            markerAnnotationView.leftCalloutAccessoryView = thumbnailImageView
            
            let rightButton = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
        }
        return view
    }

}


