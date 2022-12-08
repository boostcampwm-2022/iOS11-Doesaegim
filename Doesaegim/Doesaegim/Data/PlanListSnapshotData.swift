//
//  PlanListSnapshotData.swift
//  Doesaegim
//
//  Created by sun on 2022/12/07.
//

import Foundation

/// PlanListViewController에서 스냅샷을 생성하는 데 필요한 데이터 
struct PlanListSnapshotData {

    // MARK: - Properties

    let section: String

    let itemID: UUID

    let row: Int?


    // MARK: - Init

    init(section: String, itemID: UUID, row: Int? = nil) {
        self.section = section
        self.itemID = itemID
        self.row = row
    }
}
