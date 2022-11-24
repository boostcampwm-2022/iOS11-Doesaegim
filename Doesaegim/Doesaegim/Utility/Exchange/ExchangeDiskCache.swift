//
//  ExchangeDiskCache.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/24.
//

import Foundation

final class ExchangeDiskCache {
    static let shared = ExchangeDiskCache()
    
    private let fileManager = FileManager.default
    
    private init() {
        creatFolder()
    }
    
    func creatFolder() {
        guard let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let directoryPath = documentPath.appendingPathComponent("ExchangeInfo")
        print(directoryPath)
        if fileManager.fileExists(atPath: directoryPath.path) {
            return
        }
        do {
            try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: false)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func fetchDirectoryURL() -> URL? {
        guard let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentPath.appendingPathComponent("ExchangeInfo")
    }
    
    func saveExchangeRateInfo(exchangeInfo: [ExchangeResponse]) {
        guard let directoryPath = fetchDirectoryURL() else { return }
        guard let data = try? JSONEncoder().encode(exchangeInfo) else { return }
        let filePath = directoryPath.appendingPathComponent("exchangeRateInfo.json")
        do {
            try data.write(to: filePath)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchExchangeRateInfo() -> [ExchangeResponse]? {
        guard let directoryPath = fetchDirectoryURL() else { return nil }
        let filePath = directoryPath.appendingPathComponent("exchangeRateInfo.json")
        
        do {
            let data = try Data(contentsOf: filePath, options: .mappedIfSafe)
            let decodeData = try JSONDecoder().decode([ExchangeResponse].self, from: data)
            print(decodeData)
            return decodeData
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
