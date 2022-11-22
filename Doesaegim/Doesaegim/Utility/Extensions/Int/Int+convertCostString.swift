//
//  Int+convertPriceString.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/21.
//

import Foundation

extension Int {
    
    func numberFormatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? "-"
    }
}
