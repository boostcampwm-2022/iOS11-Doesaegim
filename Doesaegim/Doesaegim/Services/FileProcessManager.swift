//
//  ImageProcessRepository.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/23.
//

import Foundation


final class FileProcessManager {
    
    // MARK: - Properties
    
    static let shared: FileProcessManager = FileProcessManager()
    let fileManager: FileManager = FileManager()
    // MARK: - Initilizer(s)
    
    private init() {  }
    
}

extension FileProcessManager {
    
    func fetchImage(with imagePath: String) -> Result<UIImage, Error> {
    
        // TODO: - 더미가 아닌 파라미터로 주어진 imagePath를 사용하기
        let dummyImagePath = "/Users/jaehoonso/Documents/default\\ image.png"
        do {
            guard let content = try fileManager.contents(atPath: dummyImagePath) else {
                return .fail
            }
            
        }
        
        
    }
    
}
