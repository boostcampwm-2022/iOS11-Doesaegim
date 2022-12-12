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
            diaryInfos = newDiaryInfos.sorted(by: sortByDate)
            
        case .failure(let error):
            print(error.localizedDescription)
            // TODO: - 에러처리
        }
    }
}

// MARK: - Sort Function(s)

extension MapViewModel {
    
    func sortByDate(_ lhs: DiaryMapInfoViewModel, _ rhs: DiaryMapInfoViewModel) -> Bool {
        return lhs.date > rhs.date
    }
    
}
