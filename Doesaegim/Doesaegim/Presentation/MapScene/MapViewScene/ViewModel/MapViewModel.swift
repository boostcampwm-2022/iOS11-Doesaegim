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
//        for count in 1...3 {
//            let dateComponent = DateComponents(year: 2022, month: 12, day: 25+count, hour: 17)
//            let date = Calendar.current.date(from: dateComponent)!
//            let dts = DiaryDTO(
//                content: "컨텐츠컨텐츠컨텐츠컨텐츠",
//                date: date,
//                images: ["/Users/jaehoonso/Documents/default\\ image.png"],
//                title: "제목입니다.제목입니다.",
//                location: LocationDTO(
//                    name: "장소\(count)",
//                    latitude: 37.5708,
//                    longitude: 126.97 + (0.01*Double(count))
//                ),
//                travel: <#T##Travel#>
//            )
//        }
//    }
    
}
