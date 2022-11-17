//
//  NSObject+Name.swift
//  Doesaegim
//
//  Created by sun on 2022/11/15.
//

import Foundation

extension NSObject {

    /// 휴먼 에러 방지를 위한 이름 생성 프로퍼티
    /// e.g. SomeView 라는 클래스에 적용시 "SomeView" 반환
    static var name: String {
        String(describing: self)
    }
}
