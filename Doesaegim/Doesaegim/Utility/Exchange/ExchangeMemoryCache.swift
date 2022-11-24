//
//  ExchangeMemoryCache.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/24.
//

import Foundation

final class ExchangeMemoryCache {
    static let shared = NSCache<NSString, NSArray>()
    
    private init() { }
    
    
}
