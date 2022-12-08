//
//  DiaryListViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/24.
//

import Foundation

final class DiaryListViewModel: DiaryListViewModelProtocol {
    
    var delegate: DiaryListViewModelDelegate?
    var travelDiaryInfos: [TravelDiaryViewModel] {
        didSet {
            delegate?.diaryInfoDidChage()
        }
    }
    var currentTravel: Travel? // 추후 삭제될 코드
    
    init() {
        self.travelDiaryInfos = []
    }
    
}

extension DiaryListViewModel {
    
    private func initializeInfo() {
        travelDiaryInfos.removeAll()
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
            
            // TODO: - let으로 바꾸기 위해 고차함수를 사용할 수 있나?
            var newInfos: [TravelDiaryViewModel] = []
            travels.forEach { travel in
                // travel안의 diary데이터를 받아온다.
                guard let id = travel.id,
                      let diaries = travel.diary?.allObjects as? [Diary],
                      let travelName = travel.name,
                      let startDate = travel.startDate else { return }
            
                // Diary를 DiaryInfoViewModel로 변환
                let diaryInfos = diaries.compactMap({
                    Diary.convertToViewModel(with: $0, id: id, name: travelName, startAt: startDate)
                }).sorted(by: sortDiaryByDate)
                
                newInfos.append(TravelDiaryViewModel(startDate: startDate, name: travelName, info: diaryInfos))
            
                // TODO: - 추후삭제
                if currentTravel == nil {
                    currentTravel = travel
                }
            }
            travelDiaryInfos = newInfos.sorted(by: sortByDate)
            
        case .failure(let error):
            print(error.localizedDescription)
            delegate?.diaryListFetchDidFail()
        }
        
    }
    
    /// 임시로 더미 다이어리 데이터를 생성해주는 메서드 입니다. 추후 삭제됩니다.
    func addDummyDiaryData() {
        guard let travel = currentTravel else { return }
        for count in 1...3 {
            let dateComponents = DateComponents(year: 2022, month: 12, day: 24+count)
            let date = Calendar.current.date(from: dateComponents)!
            let dto = DiaryDTO(
                id: UUID(),
                content: "콘텐츠 콘텐츠 콘텐츠 \(count)",
                date: date,
                images: [],
                title: "제목\(count)",
                location: LocationDTO(
                    name: "위치",
                    latitude: 37.5700,
                    longitude: 126.97 + Double(count)*0.01
                ),
                travel: travel
            )
            Diary.addAndSave(with: dto)
        }
    }
    
    private func sortDiaryByDate(_ lhs: DiaryInfoViewModel, _ rhs: DiaryInfoViewModel) -> Bool {
        let formatter = Date.yearTominuteFormatterWithoutSeparator
        let date1 = formatter.string(from: lhs.date)
        let date2 = formatter.string(from: rhs.date)

        return date1 > date2
    }
    
    private func sortByDate(
        _ lhs: TravelDiaryViewModel,
        _ rhs: TravelDiaryViewModel
    ) -> Bool {
        return lhs.startDate > rhs.startDate
    }
    
}
