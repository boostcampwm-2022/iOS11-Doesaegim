//
//  FaceDetectViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/29.
//

import UIKit
import CoreML
import Vision


final class FaceDetectViewModel: FaceDetectViewModelProtocol {
    var delegate: FaceDetectViewModeleDelegate?
    // TODO: - boundInfos didSet... 변경에 따른 컬렉션뷰도 변경하도록 수정하기
    var detectInfos: [DetectInfoViewModel] {
        didSet {
            delegate?.detectInfoDidChange()
        }
    }
    var pathLayer: CALayer?
    var image: UIImage?
    
    private lazy var faceDetectionRequest
        = VNDetectFaceRectanglesRequest(completionHandler: handleDetectedFaces)
    
    init(image: UIImage?) {
        self.image = image
        detectInfos = []
    }
    
    init(imageData: Data) {
        self.image = UIImage(data: imageData)
        detectInfos = []
    }
}

extension FaceDetectViewModel {
    
    /// 얼굴인식 request를 담은 배열을 반환한다.
    /// - Returns: 얼굴인식 request, `VNRequest`배열
    fileprivate func createVisionRequest() -> [VNRequest] {
        var requests: [VNRequest] = []
        
        // 얼굴 탐지 request
        requests.append(faceDetectionRequest)
        
        return requests
    }
    
    func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation) {
        detectInfos.removeAll() // 비워주지 않으면 요청을 여러번 처리하게 된다.
        let reqeusts = createVisionRequest()
        // reqeust handler 생성
        let imageRequestHandler = VNImageRequestHandler(
            cgImage: image,
            orientation: orientation,
            options: [:]
        )
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform(reqeusts)
            } catch {
                print(error.localizedDescription)
                // TODO: - 에러처리. 알림 등
                return
            }
        }
    }
    
    func addDetectInfo(with image: UIImage?, boundingBox: CGRect) {
        guard let image = image else { return }

//        print(image.size.width, image.size.height)
        print(boundingBox.origin.x, boundingBox.origin.y)
        
        let xCoordinate = image.size.width * boundingBox.origin.x
        let yCoordinate = (image.size.height * (1 - boundingBox.origin.y)) / 2
        let width = image.size.width * boundingBox.size.width
        let height = image.size.height * boundingBox.size.height
//        print(image.size.width, xCoordinate, yCoordinate)
//        print(boundingBox)

        let rect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
        
        guard let croppedImage = cropImage(of: image, with: rect) else { return }
        let newDetectInfo = DetectInfoViewModel(uuid: UUID(), image: croppedImage, bound: rect)
        detectInfos.append(newDetectInfo)
//        print(detectInfos.count)
    }
    
    func addDetectInfo(with image: UIImage?, bound: CGRect) {
        guard let image = image,
              let croppedImage = cropImage(of: image, with: bound) else { return }
        
        let newDetectInfo = DetectInfoViewModel(uuid: UUID(), image: croppedImage, bound: bound)
        
        print(bound)
        
        detectInfos.append(newDetectInfo)
    }
    
    func cropImage(of image: UIImage?, with cropRect: CGRect) -> UIImage? {
        
        guard let image = image,
              let sourceCGImage = image.cgImage,
              let croppingCGImage = sourceCGImage.cropping(to: cropRect) else { return nil }
        
        let croppedImage = UIImage(
            cgImage: croppingCGImage,
            scale: image.imageRendererFormat.scale,
            orientation: image.imageOrientation
        )
        
        return croppedImage
    }
    
}

// MARK: - Handler

extension FaceDetectViewModel {
    fileprivate func handleDetectedFaces(request: VNRequest?, error: Error?) {
        // TODO: - 사용자에게 알림 등 에러처리.
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // TODO: - 인식한 얼굴의 위치에 사각형을 그려주는 작업. 화면에 그리는 것이기 때문에 main thread에서 작업해야 함.
        DispatchQueue.main.async {
            guard let drawLayer = self.pathLayer,
                  let results = request?.results as? [VNFaceObservation] else { return }
            self.delegate?.drawFaceDetection(faces: results, onImageWithBounds: drawLayer.bounds)
            drawLayer.setNeedsDisplay()
        }
    }

}
