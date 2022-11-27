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
//
//    "ttb": "942.44",
//    "tts": "961.47",
//    "deal_bas_r": "951.96",
//    "bkpr": "951",
//    "yy_efee_r": "0",
//    "ten_dd_efee_r": "0",
//
//    "kftc_deal_bas_r": "951.96",
    
}
