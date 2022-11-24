//
//  DiaryListViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/24.
//

import Foundation

final class DiaryListViewModel: DiaryListViewModelProtocol {
    
    var delegate: DiaryListViewModelDelegate?
    var diaryInfos: [DiaryInfoViewModel] { // 여행UUID: 다이어리 목록
        didSet {
            delegate?.diaryInfoDidChage()
        }
    }
    
    init() {
        self.diaryInfos = []
    }
    
}

extension DiaryListViewModel {
    
    private func initializeInfo() {
        diaryInfos = []
    }
    
    func fetchDiary() {
        // 1. 여행정보를 불러온다.
        // 2. 여행 정보별로 다이어리의 목록을 불러온다.
        // 3. 여행의 UUID를 키값으로하고, 다이어리의 배열로 하는 사전을 만든다.
        // 4. 그런데 사전은 순서대로 출력되리라는 보장이 없는 자료형이기 때문에 고민이되네...
        // 5. DiaryInfoViewModel의 배열로하고, 그 뷰모델 안에 travel의 travelID를 저장해주어야할까?
        // 6. 순서대로 출력하기 번거로울 것 같으니 일단 배열로만 해보자!
        
        // TODO: - 페이지네이션 추후구현
        
        initializeInfo()
        let travelFetchResult = PersistentRepository.shared.fetchTravel()
        switch travelFetchResult {
        case .success(let travels):
            var newDiaries: [DiaryInfoViewModel] = []
            travels.forEach { travel in
                // travel안의 diary데이터를 받아온다.
                guard let diaries = travel.diary?.allObjects as? [Diary] else { return }
                diaries.forEach { diary in
                    guard var diaryInfo = Diary.convertToViewModel(with: diary) else { return }
                    diaryInfo.travelID = travel.id
                    diaryInfo.travelName = travel.name
                    newDiaries.append(diaryInfo)
                    
                }
            }
            diaryInfos = newDiaries
            
        case .failure(let error):
            print(error.localizedDescription)
            // TODO: - 에러처리
        }
        
    }
    
}
