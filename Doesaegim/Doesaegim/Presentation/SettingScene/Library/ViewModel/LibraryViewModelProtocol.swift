//
//  LibraryViewModelProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/12.
//

import Foundation


protocol LibraryViewModelProtocol {
    
    var delegate: LibraryViewModelDelegate? { get set }
    var licenseInfos: [LibraryInfoViewModel] { get set }
    
    func loadData()
    
}

protocol LibraryViewModelDelegate {
    
    func licenseViewShouldUpdated()
    
}
