//
//  DoesaegimTests.swift
//  DoesaegimTests
//
//  Created by Jaehoon So on 2022/11/10.
//

import XCTest
import CoreData
@testable import Doesaegim

final class DoesaegimTests: XCTestCase {

    override func setUpWithError() throws {
        // 테스트 준비
    }

    override func tearDownWithError() throws {
        
        PersistentManager.shared.deleteAll(request: Travel.fetchRequest())
        PersistentManager.shared.deleteAll(request: Plan.fetchRequest())
        PersistentManager.shared.deleteAll(request: Expense.fetchRequest())
        PersistentManager.shared.deleteAll(request: Diary.fetchRequest())
        PersistentManager.shared.deleteAll(request: Location.fetchRequest())
        
    }

    func test01_Travel객체생성() {
        let seoulTravel = TravelDTO(name: "서울여행", startDate: Date(), endDate: Date())
        let tokyoTravel = TravelDTO(name: "도쿄여행", startDate: Date(), endDate: Date())
        let parisTravel = TravelDTO(name: "파리여행", startDate: Date(), endDate: Date())
        
        do {
            try Travel.addAndSave(with: seoulTravel)
            try Travel.addAndSave(with: tokyoTravel)
            try Travel.addAndSave(with: parisTravel)
        } catch {
            print(error.localizedDescription)
        }
        let context = PersistentManager.shared.context
        let travels = try? context.fetch(Travel.fetchRequest())
        
        XCTAssertEqual(travels?.count, 3)
    }
    
    func test02_Plan객체생성() {
        let plan1 = PlanDTO(name: "짐 싸기", date: Date(), content: "옷 챙기죠")
        let plan2 = PlanDTO(name: "짐 싸기", date: Date(), content: "옷 챙기죠")
        let plan3 = PlanDTO(name: "짐 싸기", date: Date(), content: "옷 챙기죠")
        
        let _ = try? Plan.addAndSave(with: plan1)
        let _ = try? Plan.addAndSave(with: plan2)
        let _ = try? Plan.addAndSave(with: plan3)
        
        let context = PersistentManager.shared.context
        let plans = try? context.fetch(Plan.fetchRequest())
        
        XCTAssertEqual(plans?.count, 3)
    }
    
    func test03_Expense객체생성() {
        let expense1 = ExpenseDTO(name: "밥 먹기", category: "식비", content: "떡볶이 먹었어요", cost: 5000, currency: "원", date: Date())
        let expense2 = ExpenseDTO(name: "밥 먹기", category: "식비", content: "떡볶이 먹었어요", cost: 5000, currency: "원", date: Date())
        let expense3 = ExpenseDTO(name: "밥 먹기", category: "식비", content: "떡볶이 먹었어요", cost: 5000, currency: "원", date: Date())
        
        let _ = try? Expense.addAndSave(with: expense1)
        let _ = try? Expense.addAndSave(with: expense2)
        let _ = try? Expense.addAndSave(with: expense3)
        
        let context = PersistentManager.shared.context
        let expenses = try? context.fetch(Expense.fetchRequest())
        
        XCTAssertEqual(expenses?.count, 3)
    }
    
    func test04_Diary객체생성() {
        let diary1 = DiaryDTO(content: "안녕하세요 안녕하세요", date: Date(), images: [], title: "여행 다녀왔어요")
        let diary2 = DiaryDTO(content: "안녕하세요 안녕하세요", date: Date(), images: [], title: "여행 다녀왔어요")
        let diary3 = DiaryDTO(content: "안녕하세요 안녕하세요", date: Date(), images: [], title: "여행 다녀왔어요")
        
        let _ = try? Diary.addAndSave(with: diary1)
        let _ = try? Diary.addAndSave(with: diary2)
        let _ = try? Diary.addAndSave(with: diary3)

        let context = PersistentManager.shared.context
        let diaries = try? context.fetch(Diary.fetchRequest())
        
        XCTAssertEqual(diaries?.count, 3)
    }
    
    func test05_Location객체생성() {
        let location1 = LocationDTO(name: "서울특별시 강서구 염창동 양천로 75길 57", latitude: 35.13142, longitude: 100)
        let location2 = LocationDTO(name: "서울특별시 강서구 염창동 양천로 75길 57", latitude: 35.13142, longitude: 100)
        let location3 = LocationDTO(name: "서울특별시 강서구 염창동 양천로 75길 57", latitude: 35.13142, longitude: 100)
        
        let _ = try? Location.addAndSave(with: location1)
        let _ = try? Location.addAndSave(with: location2)
        let _ = try? Location.addAndSave(with: location3)

        let context = PersistentManager.shared.context
        let locations = try? context.fetch(Location.fetchRequest())
        
        XCTAssertEqual(locations?.count, 3)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
