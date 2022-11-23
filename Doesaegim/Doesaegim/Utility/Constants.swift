//
//  Constants.swift
//  Doesaegim
//
//  Created by sun on 2022/11/14.
//

import Foundation

enum FontSize {

    static let title: CGFloat = 20

    static let body: CGFloat = 16

    static let caption: CGFloat = 12
}

enum ExchangeAPI {
    
    // MARK: - 환율 API 관련 정보
    /// 배포할 때, secret 이란 폴더를 하나 만들어서 .gitignore 파일에 안올라가게 해야할 거 같습니다.
    static let exchangeURL = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON"
    static let authkey = "wHpfEyMGBchJW4ipjjz4hXYximQmP0KR"
    static let dataCode = "AP01"
}
