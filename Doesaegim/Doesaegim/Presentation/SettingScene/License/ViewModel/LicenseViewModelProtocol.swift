//
//  LicenseViewModelProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/12.
//

import Foundation


protocol LicenseViewModelProtocol {
    
    var delegate: LicenseViewModelDelegate? { get set }
    var licenseInfos: [LicenseInfoViewModel] { get set }
    
    func loadData()
    
}

protocol LicenseViewModelDelegate {
    
    func licenseViewShouldUpdated()
    
}
