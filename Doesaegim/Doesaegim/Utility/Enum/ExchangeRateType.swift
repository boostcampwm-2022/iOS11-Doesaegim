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
