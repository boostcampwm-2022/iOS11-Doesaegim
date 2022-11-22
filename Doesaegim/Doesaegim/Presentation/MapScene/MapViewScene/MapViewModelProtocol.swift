//
//  MapViewModelProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/22.
//

import Foundation


protocol MapViewModelProtocol: AnyObject {
    
    var delegate: MapViewModelDelegate? { get set }
    var diaryInfos: [DiaryMapInfoViewModel] { get set }
    
}

protocol MapViewModelDelegate: AnyObject {
    
    func mapViewDairyInfoDidChage()
    
}
