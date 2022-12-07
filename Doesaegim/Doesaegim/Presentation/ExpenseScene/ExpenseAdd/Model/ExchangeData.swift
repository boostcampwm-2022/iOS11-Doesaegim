//
//  ExchangeData.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/07.
//

import Foundation

class ExchangeData {
    let currencyCode: String
    let tradingStandardRate: String
    let currencyName: String
    
    init(currencyCode: String, tradingStandardRate: String, currencyName: String) {
        self.currencyCode = currencyCode
        self.tradingStandardRate = tradingStandardRate
        self.currencyName = currencyName
    }
    
    static let list: [ExchangeData] = [
        ExchangeData(currencyCode: "AED", tradingStandardRate: "356", currencyName: "아랍에미리트 디르함"),
        ExchangeData(currencyCode: "AUD", tradingStandardRate: "875", currencyName: "호주 달러"),
        ExchangeData(currencyCode: "BHD", tradingStandardRate: "3,471", currencyName: "바레인 디나르"),
        ExchangeData(currencyCode: "BND", tradingStandardRate: "963", currencyName: "브루나이 달러"),
        ExchangeData(currencyCode: "CAD", tradingStandardRate: "958", currencyName: "캐나다 달러"),
        ExchangeData(currencyCode: "CHF", tradingStandardRate: "1,389", currencyName: "스위스 프랑"),
        ExchangeData(currencyCode: "CNH", tradingStandardRate: "187", currencyName: "위안화"),
        ExchangeData(currencyCode: "DKK", tradingStandardRate: "184", currencyName: "덴마아크 크로네"),
        ExchangeData(currencyCode: "EUR", tradingStandardRate: "1,370", currencyName: "유로"),
        ExchangeData(currencyCode: "GBP", tradingStandardRate: "1,588", currencyName: "영국 파운드"),
        ExchangeData(currencyCode: "HKD", tradingStandardRate: "168", currencyName: "홍콩 달러"),
        ExchangeData(currencyCode: "IDR(100)", tradingStandardRate: "8", currencyName: "인도네시아 루피아"),
        ExchangeData(currencyCode: "JPY(100)", tradingStandardRate: "955", currencyName: "일본 옌"),
        ExchangeData(currencyCode: "KRW", tradingStandardRate: "1", currencyName: "한국 원"),
        ExchangeData(currencyCode: "KWD", tradingStandardRate: "4,262", currencyName: "쿠웨이트 디나르"),
        ExchangeData(currencyCode: "MYR", tradingStandardRate: "297", currencyName: "말레이지아 링기트"),
        ExchangeData(currencyCode: "NOK", tradingStandardRate: "130", currencyName: "노르웨이 크로네"),
        ExchangeData(currencyCode: "NZD", tradingStandardRate: "827", currencyName: "뉴질랜드 달러"),
        ExchangeData(currencyCode: "SAR", tradingStandardRate: "348", currencyName: "사우디 리얄"),
        ExchangeData(currencyCode: "SEK", tradingStandardRate: "125", currencyName: "스웨덴 크로나"),
        ExchangeData(currencyCode: "SGD", tradingStandardRate: "963", currencyName: "싱가포르 달러"),
        ExchangeData(currencyCode: "THB", tradingStandardRate: "37", currencyName: "태국 바트"),
        ExchangeData(currencyCode: "USD", tradingStandardRate: "1,309", currencyName: "미국 달러")
        ]
}
