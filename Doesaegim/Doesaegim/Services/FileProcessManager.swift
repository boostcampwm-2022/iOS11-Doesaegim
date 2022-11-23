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
    
    func fetchImages(with imagePaths: [String]) -> [Data] {
        var imageDatas: [Data] = []
        imagePaths.forEach { imagePath in
            let result = fetchImage(with: imagePath)
            switch result {
            case .success(let data):
                imageDatas.append(data)
            case .failure(let error):
                print(error.localizedDescription)
                // TODO: - 에러처리
            }
        }
        return imageDatas
    }
    
    func fetchImage(with imagePath: String) -> Result<Data, Error> {
    
        // TODO: - 더미가 아닌 파라미터로 주어진 imagePath를 사용하기
//        guard let imageURL = URL(string: imagePath) else {
//            return .failure(FileManagerError.fetchFailure(.image))
//        }
        guard let dummyImageURL = URL(string: "/Users/jaehoonso/Documents/default\\ image.png") else {
            return .failure(FileManagerError.fetchFailure(.image))
        }
        do {
            let imageData = try Data(contentsOf: dummyImageURL)
            return .success(imageData)
        } catch {
            return .failure(FileManagerError.fetchFailure(.image))
        }
        
        return .failure(FileManagerError.fetchFailure(.image))
    }
    
}
