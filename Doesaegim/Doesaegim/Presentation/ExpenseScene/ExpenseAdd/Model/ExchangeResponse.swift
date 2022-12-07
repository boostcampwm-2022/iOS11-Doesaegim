//
//  ExchangeResponse.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/22.
//

import Foundation

class ExchangeResponse: Codable {
    let currencyCode: String     // 통화코드
    let tradingStandardRate: String  // 매매기준율
    let currencyName: String      // 국가, 통화명
    
    enum CodingKeys: String, CodingKey {
        case currencyCode = "cur_unit"
        case tradingStandardRate = "deal_bas_r"
        case currencyName = "cur_nm"
    }
}
