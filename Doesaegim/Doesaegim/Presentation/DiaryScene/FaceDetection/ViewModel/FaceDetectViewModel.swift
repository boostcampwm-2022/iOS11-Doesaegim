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
    var detectInfos: [DetectInfoViewModel] {
        didSet {
            delegate?.detectInfoDidChange()
        }
    }
    var pathLayer: CALayer?
    var image: UIImage?
    
    private lazy var faceDetectionRequest
        = VNDetectFaceRectanglesRequest(completionHandler: handleDetectedFaces)
    
    init() {
        detectInfos = []
        // 시뮬레이터에서 동작할 수 있도록
#if targetEnvironment(simulator)
        faceDetectionRequest.usesCPUOnly = true
#endif
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
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                try imageRequestHandler.perform(reqeusts)
            } catch {
                print(error.localizedDescription)
                self?.delegate?.faceDetectDidFail()
                return
            }
        }
    }
    
    func addDetectInfo(with image: UIImage?, downsampledImage: UIImage?, boundingBox: CGRect) {
        guard let image = image,
              let downsampledImage
        else { return }

        let rect = calculateBounds(with: image, boundingBox: boundingBox)
        let downsampledRect = calculateBounds(with: downsampledImage, boundingBox: boundingBox)
        
        guard let croppedImage = cropImage(of: image, with: rect) else { return }
        let newDetectInfo = DetectInfoViewModel(
            uuid: UUID(),
            image: croppedImage,
            bound: rect,
            downsampledBounds: downsampledRect
        )
        detectInfos.append(newDetectInfo)
    }

    private func calculateBounds(with image: UIImage, boundingBox: CGRect) -> CGRect {
        let width = image.size.width * boundingBox.size.width
        let height = image.size.height * boundingBox.size.height
        let xCoordinate = image.size.width * boundingBox.origin.x
        let yCoordinate = (image.size.height * (1 - boundingBox.origin.y)) - height

        return CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
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
        if let error = error {
            print(error.localizedDescription)
            delegate?.faceDetectDidFail()
            return
        }
        
        // 인식한 얼굴의 위치에 사각형을 그려주는 작업. 화면에 그리는 것이기 때문에 main thread에서 작업해야 함.
        DispatchQueue.main.async {
            guard let drawLayer = self.pathLayer,
                  let results = request?.results as? [VNFaceObservation] else { return }
            if results.isEmpty { self.delegate?.faceDetectCountZero() } // 인식된 얼굴이 없을 때 delegate메서드 호출
            self.delegate?.drawFaceDetection(faces: results, onImageWithBounds: drawLayer.bounds)
            drawLayer.setNeedsDisplay()
        }
    }

}
