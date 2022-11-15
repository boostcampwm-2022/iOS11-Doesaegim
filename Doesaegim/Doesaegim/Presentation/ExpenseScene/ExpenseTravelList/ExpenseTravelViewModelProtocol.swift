//
//  ExpenseTravelListControllerProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/15.
//

import Foundation


protocol ExpenseTravelViewModelProtocol {
    
    var delegate: ExpenseTravelListDelegate? { get set }
    
}

protocol ExpenseTravelListDelegate {
    
    func applyTravelSnapShot()
    func applyPlaceholdLabel()
    
}
