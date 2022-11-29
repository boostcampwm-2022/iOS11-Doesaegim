//
//  FaceDetectController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/28.
//

import UIKit
import CoreML
import Vision


import SnapKit

/// 사진 디테일 화면으로부터 조회하고 있는 이미지를 전달받는다. Data타입, UImage타입 둘다 상관 없다.
/// 이미지에서 얼굴을 탐지하고 다음 화면인 이미지 선택화면으로 넘긴다.

final class FaceDetectController: UIViewController {

    // MARK: - Properties
    
    private var currentImage: UIImage?
    
    // bounding box를 그려주는 path
    private var pathLayer: CALayer?
    
    private lazy var faceDetectionRequest
        = VNDetectFaceRectanglesRequest(completionHandler: handleDetectedFaces)
    private lazy var faceLandmarkReqeust
        = VNDetectFaceLandmarksRequest(completionHandler: handleDetectedFaceLandmarks)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    // MARK: - Initializer(s)
    
    /// 기본이미지를 받아오는 생성자. 실험시 이 생성자를 사용한다.
    init() {
//        self.currentImage = UIImage(named: "monalisa")
        self.currentImage = UIImage(named: "face_example")
        imageView.image = self.currentImage
        super.init(nibName: nil, bundle: nil)
    }
    
    init(data: Data) {
        let image = UIImage(data: data)
        self.currentImage = image
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(image: UIImage) {
        self.currentImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        configureConstraints()
        
#if targetEnvironment(simulator)
        faceDetectionRequest.usesCPUOnly = true
        faceLandmarkReqeust.usesCPUOnly = true
#endif
    }
    
    override func viewDidLayoutSubviews() {
        progress()
    }
}

// MARK: - Functions

extension FaceDetectController {

    // MARK: - Configuration
    
    private func configureSubviews() {
        view.addSubview(imageView)
    }
    
    private func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.height.equalTo(imageView.snp.width)
        }
    }
    
    // MARK: - ETC
    
    private func progress() {
        print(#function)
        guard let image = currentImage,
              let cgImage = image.cgImage else { return }
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        
        show(image)
        // 얼굴인식 작업 시작
        performVisionReqeust(image: cgImage, orientation: cgOrientation)
    }
    
    /// 화면에 나타날 이미지를 설정하고 얼굴인식 시 그려줄 CALayer를 지정해주는 메서드
    /// - Parameter image: 화면에 나타나고, 얼굴인식 작업에 사용할 `UIImage`
    private func show(_ image: UIImage) {
        print(#function)
        // pathLayer 초기화
        pathLayer?.removeFromSuperlayer()
        pathLayer = nil
        imageView.image = nil
        
        let correctedImage = scaleAndOrient(image: image)
        
        imageView.image = correctedImage
        
        guard let cgImage = correctedImage.cgImage else {
            print("Trying to show an image not backed by CGImage!")
            return
        }
        
        let fullImageWidth = CGFloat(cgImage.width)
        let fullImageHeight = CGFloat(cgImage.height)
        
        let imageFrame = imageView.frame
        let widthRatio = fullImageWidth / imageFrame.width
        let heightRatio = fullImageHeight / imageFrame.height
        
        // ScaleAspectFit: The image will be scaled down according to the stricter dimension.
        let scaleDownRatio = max(widthRatio, heightRatio)
        
        // Cache image dimensions to reference when drawing CALayer paths.
        var imageWidth = fullImageWidth / scaleDownRatio
        var imageHeight = fullImageHeight / scaleDownRatio
        
        // Prepare pathLayer to hold Vision results.
        let xLayer = (imageFrame.width - imageWidth) / 2
        let yLayer = imageView.frame.minY + (imageFrame.height - imageHeight) / 2
        let drawingLayer = CALayer()
        drawingLayer.bounds = CGRect(x: xLayer, y: yLayer, width: imageWidth, height: imageHeight)
        drawingLayer.anchorPoint = CGPoint.zero
        drawingLayer.position = CGPoint(x: xLayer, y: yLayer)
        drawingLayer.opacity = 0.5
        pathLayer = drawingLayer
        print("pathLayer 초기화 완료!")
        view.layer.addSublayer(pathLayer!)
    }
    
    /// 이미지의 해상도를 재조정하고 상태에 따라 방향전환을 해주는 메서드
    /// - Parameter image: 반영할 `UIImage`
    /// - Returns: 해상도와 방향이 조정된 `UIImage`
    private func scaleAndOrient(image: UIImage) -> UIImage {
        
        let maxResolution: CGFloat = 640
        
        guard let cgImage = image.cgImage else { return image }
        
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        print(#function, width, height)
        var transform = CGAffineTransform.identity
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let isWidthBiggerThanMaxResolution = width > maxResolution
        let isHeightBiggerThanMaxResolution = height > maxResolution
        if isWidthBiggerThanMaxResolution || isHeightBiggerThanMaxResolution {
            let ratio = width / height
            if width > height {
                bounds.size.width = maxResolution
                bounds.size.height = round(maxResolution / ratio)
            } else {
                bounds.size.width = round(maxResolution * ratio)
                bounds.size.height = maxResolution
            }
        }
        
        let scaleRatio = bounds.size.width / width
        let orientation = image.imageOrientation
        switch orientation {
        case .up:
            transform = .identity
        case .down:
            transform = CGAffineTransform(translationX: width, y: height).rotated(by: .pi)
        case .left:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: 0, y: width).rotated(by: 3.0 * .pi / 2.0)
        case .right:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: height, y: 0).rotated(by: .pi / 2.0)
        case .upMirrored:
            transform = CGAffineTransform(translationX: width, y: 0).scaledBy(x: -1, y: 1)
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0, y: height).scaledBy(x: 1, y: -1)
        case .leftMirrored:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: height, y: width).scaledBy(x: -1, y: 1).rotated(by: 3.0 * .pi / 2.0)
        case .rightMirrored:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(scaleX: -1, y: 1).rotated(by: .pi / 2.0)
        default:
            transform = .identity
        }
        
        return UIGraphicsImageRenderer(size: bounds.size).image { rendererContext in
            let context = rendererContext.cgContext
            
            if orientation == .right || orientation == .left {
                context.scaleBy(x: -scaleRatio, y: scaleRatio)
                context.translateBy(x: -height, y: 0)
            } else {
                context.scaleBy(x: scaleRatio, y: -scaleRatio)
                context.translateBy(x: 0, y: -height)
            }
            
            context.concatenate(transform)
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
    }
    
}

extension FaceDetectController {
    fileprivate func performVisionReqeust(image: CGImage, orientation: CGImagePropertyOrientation) {
        print(#function)
        let reqeusts = createVisionReqeusts()
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
        
        // request를 request handler에 보낸다.
    }
    
    /// 얼굴인식 request를 담은 배열을 반환한다.
    /// - Returns: 얼굴인식 request, `VNRequest`배열
    fileprivate func createVisionReqeusts() -> [VNRequest] {
        print(#function)
        var requests: [VNRequest] = []
        
        // 얼굴 탐지 request
        requests.append(faceDetectionRequest)
        requests.append(faceLandmarkReqeust)
        
        return requests
    }
}

// MARK: - Handlers

extension FaceDetectController {
    
    fileprivate func handleDetectedFaces(request: VNRequest?, error: Error?) {
        print(#function)
        // TODO: - 사용자에게 알림 등 에러처리.
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // TODO: - 인식한 얼굴의 위치에 사각형을 그려주는 작업. 화면에 그리는 것이기 때문에 main thread에서 작업해야 함.
        // TODO: - 강한참조?
        DispatchQueue.main.async {
            guard let drawLayer = self.pathLayer,
                  let results = request?.results as? [VNFaceObservation] else { return }
            print(drawLayer.bounds)
            self.draw(faces: results, onImageWithBounds: drawLayer.bounds)
            print("drawLayer 있어요!!")
            drawLayer.setNeedsDisplay()
        }
    }
    
    fileprivate func handleDetectedFaceLandmarks(request: VNRequest?, error: Error?) {
        print(#function)
        if let error = error {
            // TODO: - 사용자에게 알림 등 에러처리.
            print(error.localizedDescription)
            return
        }
        
        // TODO: - 인식한 이목구비를 그려준다. 이 또한 화면에 그리는 작업이므로 main thread에서 작업해야한다.
        DispatchQueue.main.async {
            guard let drawLayer = self.pathLayer,
                  let results = request?.results as? [VNFaceObservation] else { return }
//            self.draw(faces: results, onImageWithBounds: drawLayer.bounds)
            drawLayer.setNeedsDisplay()
        }
        
    }
}

// MARK: - Drawing

extension FaceDetectController {
    
    fileprivate func boundingBox(forRegionOfInterest: CGRect, withInImageBounds bounds: CGRect) -> CGRect {
        print(#function, bounds)
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        
        var rect = forRegionOfInterest
        
        rect.origin.x *= imageWidth
        rect.origin.x += bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y
        
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        
        return rect
    }
    
    fileprivate func shapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
        print(#function, frame)
        let layer = CAShapeLayer()
        
        layer.fillColor = nil // 박스안에 색을 채우지 않음
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.borderWidth = 2
        
        layer.borderColor = color.cgColor
        
        layer.anchorPoint = .zero
        layer.frame = frame
        layer.masksToBounds = true
        
        layer.transform = CATransform3DMakeScale(1, -1, 1)
        
        return layer
    }
    
    fileprivate func draw(faces: [VNFaceObservation], onImageWithBounds bounds: CGRect) {
        print(#function)
        CATransaction.begin()
        faces.forEach { observation in
            let faceBox = boundingBox(forRegionOfInterest: observation.boundingBox, withInImageBounds: bounds)
            let faceLayer = shapeLayer(color: .yellow, frame: faceBox)
            
            pathLayer?.addSublayer(faceLayer)
        }
        
        CATransaction.commit()
    }
}
