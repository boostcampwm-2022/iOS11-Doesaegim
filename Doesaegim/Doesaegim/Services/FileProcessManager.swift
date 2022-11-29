//
//  ImageProcessRepository.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/23.
//

import UIKit


final class FileProcessManager {
    
    // MARK: - Properties
    
    static let shared: FileProcessManager = FileProcessManager()
    private let fileManager: FileManager = FileManager()


    // MARK: - Initilizer(s)
    
    private init() {  }
    
}

// MARK: - Fetching and Saving Functions
extension FileProcessManager {

    // MARK: - Save Function

    /// 이미지를 저장하고 성공하면 저장 위치(상대 경로)를, 실패하면 nil 리턴
    func saveImage(_ image: UIImage, path: String) -> String? {
        guard let data = image.jpegData(compressionQuality: Metric.compressionQuality),
              let url = url(appendingPathComponent: path)
        else {
            return nil
        }

        do {
            try data.write(to: url)
        } catch {
            return nil
        }

        return path
    }


    // MARK: - Fetch Functions
    
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
        guard let url = url(appendingPathComponent: imagePath)
        else {
            return .failure(FileManagerError.fetchFailure(.image))
        }

        do {
            let imageData = try Data(contentsOf: url)
            return .success(imageData)
        } catch {
            return .failure(FileManagerError.fetchFailure(.image))
        }
    }


    // MARK: - Delete Functions

    /// 인자로 주어진 값들을 경로로 활용해 해당 경로에 이미지가 존재하면 이미지를 리턴
    @discardableResult
    func deleteImage(at imagePath: String) -> Bool {
        guard let url = url(appendingPathComponent: imagePath)
        else {
            return false
        }

        do {
            try fileManager.removeItem(at: url)
        } catch {
            return false
        }

        return true
    }

    /// userDomainMask의 document directory에 인자를 최종 경로로 하는 url 생성
    private func url(appendingPathComponent path: String) -> URL? {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return nil
        }

        return documentsDirectory.appendingPathComponent(path.replacingOccurrences(of: "/", with: "-"))
    }
}


// MARK: - Constants
fileprivate extension FileProcessManager {
    enum Metric {
        /// jpeg로 압축 시 압축 품질
        static let compressionQuality: CGFloat = 0.85
    }
}
