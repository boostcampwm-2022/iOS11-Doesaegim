//
//  UserDefaults+.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/12.
//

import Foundation


extension UserDefaults {
    
    func hasValue(for key: String) -> Bool {
        return object(forKey: key) != nil
    }
    
}
