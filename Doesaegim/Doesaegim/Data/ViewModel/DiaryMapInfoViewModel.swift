//
//  DiaryMapViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/22.
//

import Foundation


struct DiaryMapInfoViewModel {
    
    let id: UUID
    let imageData: [Data]
    let title: String
    let content: String
    let date: Date
    let latitude: Double
    let longitude: Double
    
}
