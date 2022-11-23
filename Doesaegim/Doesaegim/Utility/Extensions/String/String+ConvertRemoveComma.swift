//
//  String+ConvertRemoveComma.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/22.
//

import Foundation

extension String {
    
    func convertRemoveComma() -> String {
        return self.components(separatedBy: [","]).joined()
    }
}
