//
//  Int+convertPriceString.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/21.
//

import Foundation

extension Int {
    
    
    /// 가격의 문자열에 1000단위마다 ,를 찍어 반환해주는 문자열이다.
    /// - Returns: ,가 포함된 가격 문자열. 백만원, 1000000을 예시로 들면 1,000,000을 반환한다.
    func convertCostString() -> String {
        var result = ""
        let costString = String(self)
        costString.reversed().enumerated().forEach { (index, number) in
            result += String(number)
            let isNotLastCharacter = index != costString.count-1
            if index % 3 == 2 && isNotLastCharacter{
                result += ","
            }
        }
        return String(result.reversed())
    }
}
