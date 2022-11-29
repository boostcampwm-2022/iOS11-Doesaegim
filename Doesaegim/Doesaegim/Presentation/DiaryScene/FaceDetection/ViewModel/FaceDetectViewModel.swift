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
    var boundingBoxes: [CGRect]
    var pathLayer: CALayer?
    var image: UIImage?
    
    private lazy var faceDetectionRequest
        = VNDetectFaceRectanglesRequest(completionHandler: handleDetectedFaces)
    
    init(image: UIImage?) {
        self.image = image
        boundingBoxes = []
    }
    
    init(imageData: Data) {
        self.image = UIImage(data: imageData)
        boundingBoxes = []
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
