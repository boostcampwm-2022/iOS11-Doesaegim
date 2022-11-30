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


    /// 이미지를 jpeg로 변환해서 파일시스템에 저장
    /// - Parameters:
    ///   - image: 저장할 UIImage
    ///   - imageID: 저장할 이미지의 아이디
    ///   - diaryID: 이미지가 속한 다이어리의 아이디
    /// - Returns: 성공 시 true, 실패 시 false
    func saveImage(_ image: UIImage, imageID: String, diaryID: UUID) -> Bool {
        guard let data = image.jpegData(compressionQuality: Metric.compressionQuality),
              let url = url(usingImageID: imageID, diaryID: diaryID)
        else {
            return false
        }

        do {
            try data.write(to: url)
        } catch {
            return false
        }

        return true
    }


    // MARK: - Fetch Functions
    
    func fetchImages(with imagePaths: [String], diaryID: UUID) -> [Data] {
        var imageDatas: [Data] = []
        imagePaths.forEach { imagePath in
            let result = fetchImage(with: imagePath, diaryID: diaryID)
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
    
    func fetchImage(with imagePath: String, diaryID: UUID) -> Result<Data, Error> {
        guard let url = url(usingImageID: imagePath, diaryID: diaryID)
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


    /// 인자로 주어진 값들을 활용해서 생성한 경로에 있는 이미지를 삭제
    /// - Parameters:
    ///   - imagePath: Diary의 images 값 혹은 PHPickerResult의 asset identifier
    ///   - diaryID: Diary의 id 값
    /// - Returns: 성공 시 true, 실패 시 fail
    @discardableResult
    func deleteImage(at imagePath: String, diaryID: UUID) -> Bool {
        guard let url = url(usingImageID: imagePath, diaryID: diaryID)
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

    /// userDomainMask의 document directory에 imageID와 noteID를 최종 경로로 하는 url 생성
    ///
    /// 하나의 사진을 여러 다이어리에 넣을 수 있어서 경로에 diaryID를 추가적으로 사용
    private func url(usingImageID imageID: String, diaryID: UUID) -> URL? {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return nil
        }
        let path = "\(imageID)\(diaryID.uuidString)".replacingOccurrences(of: "/", with: "-")
        return documentsDirectory.appendingPathComponent(path)
    }
}


// MARK: - Constants
fileprivate extension FileProcessManager {
    enum Metric {
        /// jpeg로 압축 시 압축 품질
        static let compressionQuality: CGFloat = 0.85
    }
}
