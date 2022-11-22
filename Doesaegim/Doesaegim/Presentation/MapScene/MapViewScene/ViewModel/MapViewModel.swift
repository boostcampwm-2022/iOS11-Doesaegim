//
//  MapViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/22.
//

import Foundation

final class MapViewModel: MapViewModelProtocol {
    
    // MARK: - Properties
    
    var delegate: MapViewModelDelegate?
    var diaryInfos: [DiaryMapInfoViewModel] {
        didSet {
            delegate?.mapViewDairyInfoDidChage()
        }
    }
    
    // MARK: - Initializers
    
    init() {
        diaryInfos = []
    }
    
}


// MARK: - Methods

extension MapViewModel {
    
    func fetchDiary() {
        let result = PersistentRepository.shared.fetchDiary()
        switch result {
        case .success(let diaries):
            // DiaryMapInfoViewModel의 배열로 변환
            var newDiaryInfos: [DiaryMapInfoViewModel] = []
            diaries.forEach { diary in
                guard let diaryInfo = Diary.convertToMapViewModel(with: diary) else { return }
                newDiaryInfos.append(diaryInfo)
            }
            diaryInfos = newDiaryInfos
            
        case .failure(let error):
            print(error.localizedDescription)
            // TODO: - 에러처리
        }
    }
    
//    func addDummyDiaryData() {
//        // 3개의 데이터를 추가
//        (0..<3).forEach { _ in
//
//            let dto = DiaryDTO(
//                content: "내용입니다.",
//                date: Date(),
//                images: [],
//                title: "제목"
//            )
//            let result = Diary.addAndSave(with: dto)
//            switch result {
//            case .success(let diary):
//                // 종로
//                let locationDTO = LocationDTO(
//                    name: "위치",
//                    latitude: 37.5700,
//                    longitude: 126.979
//                )
//                diary.location = Location.addAndSave(with: locationDTO)
//
//            case .failure(let error):
//                print(error?.localizedDescription)
//                // TODO: - 에러처리
//            }
//        }
//    }
    
}
