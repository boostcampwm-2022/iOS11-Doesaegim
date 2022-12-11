//
//  ExchangeRateType.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/22.
//

import Foundation

enum ExchangeRateType: String {
    case AED
    case AUD
    case BHD
    case BND
    case CAD
    case CHF
    case CNH
    case DKK
    case EUR
    case GBP
    case HKD
    case IDR
    case JPY
    case KRW
    case KWD
    case MYR
    case NOK
    case NZD
    case SAR
    case SEK
    case SGD
    case THB
    case USD
    
    var currencyCode: String {
        switch self {
        case .IDR:
            return "IDR(100)"
        case .JPY:
            return "JPY(100)"
        default:
            return rawValue
        }
    }
    
    var icon: Character {
        switch self {
        case .AED:
            return "🇦🇪"
        case .AUD:
            return "🇦🇺"
        case .BHD:
            return "🇧🇭"
        case .BND:
            return "🇧🇳"
        case .CAD:
            return "🇨🇦"
        case .CHF:
            return "🇨🇭"
        case .CNH:
            return "🇨🇳"
        case .DKK:
            return "🇩🇰"
        case .EUR:
            return "🇪🇺"
        case .GBP:
            return "🇬🇧"
        case .HKD:
            return "🇭🇰"
        case .IDR:
            return "🇮🇩"
        case .JPY:
            return "🇯🇵"
        case .KRW:
            return "🇰🇷"
        case .KWD:
            return "🇰🇼"
        case .MYR:
            return "🇲🇾"
        case .NOK:
            return "🇳🇴"
        case .NZD:
            return "🇳🇿"
        case .SAR:
            return "🇸🇦"
        case .SEK:
            return "🇸🇪"
        case .SGD:
            return "🇸🇬"
        case .THB:
            return "🇹🇭"
        case .USD:
            return "🇺🇸"
        }
    }
    
    var currencyName: String {
        switch self {
        case .AED:
            return "아랍에미리트 디르함"
        case .AUD:
            return "호주 달러"
        case .BHD:
            return "바레인 디나르"
        case .BND:
            return "브루나이 달러"
        case .CAD:
            return "캐나다 달러"
        case .CHF:
            return "스위스 프랑"
        case .CNH:
            return "위안화"
        case .DKK:
            return "덴마크 크로네"
        case .EUR:
            return "유로"
        case .GBP:
            return "영국 파운드"
        case .HKD:
            return "홍콩 달러"
        case .IDR:
            return "인도네시아 루피아"
        case .JPY:
            return "일본 옌"
        case .KRW:
            return "한국 원"
        case .KWD:
            return "쿠웨이트 디나르"
        case .MYR:
            return "말레이지아 링기트"
        case .NOK:
            return "노르웨이 크로네"
        case .NZD:
            return "뉴질랜드 달러"
        case .SAR:
            return "사우디 리얄"
        case .SEK:
            return "스웨덴 크로나"
        case .SGD:
            return "싱가포르 달러"
        case .THB:
            return "태국 바트"
        case .USD:
            return "미국 달러"
        }
    }
    
    init?(currencyCode: String) {
        switch currencyCode {
        case "IDR(100)":
            self = .IDR
        case "JPY(100)":
            self = .JPY
        default:
            self = ExchangeRateType(rawValue: currencyCode) ?? .AED
        }
    }
}
