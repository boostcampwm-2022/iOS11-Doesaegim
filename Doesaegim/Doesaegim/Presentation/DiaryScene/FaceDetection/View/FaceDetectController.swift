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
    
    typealias DataSource
        = UICollectionViewDiffableDataSource<SectionType, DetectInfoViewModel>
    typealias CellRegistration
        = UICollectionView.CellRegistration<DetectedFaceCell, DetectInfoViewModel>
    typealias SnapShot
        = NSDiffableDataSourceSnapshot<SectionType, DetectInfoViewModel>
    
    // MARK: - Properties
    
    private var currentImage: UIImage?
    
    // bounding box를 그려주는 path
    private var pathLayer: CALayer?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 10
        
        return collectionView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .primaryOrange
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    var detectDataSource: DataSource?
    
    var viewModel: FaceDetectViewModelProtocol?
    
    // MARK: - Initializer(s)
    
    /// 기본이미지를 받아오는 생성자. 실험시 이 생성자를 사용한다.
    init() {
        super.init(nibName: nil, bundle: nil)
        self.currentImage = UIImage(named: "face_example")
//        self.currentImage = UIImage(named: "monalisa")
        imageView.image = self.currentImage
        self.viewModel = FaceDetectViewModel(image: UIImage(named: "face_example"))
//        self.viewModel = FaceDetectViewModel(image: UIImage(named: "monalisa"))
        self.viewModel?.delegate = self
    }
    
    init(data: Data, viewModel: FaceDetectViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        let image = UIImage(data: data)
        self.currentImage = image
        self.viewModel = viewModel
        self.viewModel?.delegate = self
    }
    
    init(image: UIImage, viewModel: FaceDetectViewModelProtocol) {
        
        super.init(nibName: nil, bundle: nil)
        self.currentImage = image
        self.viewModel = viewModel
        self.viewModel?.delegate = self
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
        configureButtonAction()
        configureCollectionViewDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        startDetect()
    }
}

// MARK: - Functions

extension FaceDetectController {

    // MARK: - Configuration
    
    private func configureSubviews() {
        view.addSubview(imageView)
        view.addSubview(collectionView)
        view.addSubview(confirmButton)
    }
    
    private func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.height.equalTo(imageView.snp.width)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(imageView.snp.bottom).offset(6)
        }
        
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(collectionView.snp.bottom).offset(6)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-6)
            $0.height.equalTo(40)
        }
    }
    
    private func configureButtonAction() {
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - Button Action
    
    @objc private func confirmButtonDidTap() {
        print("버튼이 탭 되었습니다~")
    }
    
    // MARK: - ETC
    
    private func startDetect() {
        guard let image = currentImage,
              let cgImage = image.cgImage,
              let viewModel = viewModel else { return }
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        
        show(image)
        // 얼굴인식 작업 시작
        
        viewModel.performVisionRequest(image: cgImage, orientation: cgOrientation)
    }
    
    /// 화면에 나타날 이미지를 설정하고 얼굴인식 시 그려줄 CALayer를 지정해주는 메서드
    /// - Parameter image: 화면에 나타나고, 얼굴인식 작업에 사용할 `UIImage`
    private func show(_ image: UIImage) {
        // pathLayer 초기화
        pathLayer?.removeFromSuperlayer()
        pathLayer = nil
        imageView.image = nil
        
        let correctedImage = scaleAndOrient(image: image)
        
        imageView.image = correctedImage
        
        guard let cgImage = correctedImage.cgImage else {
            print("CGImage로 변환되지 않는 이미지 형식입니다.")
            return
        }
        
        let fullImageWidth = CGFloat(cgImage.width)
        let fullImageHeight = CGFloat(cgImage.height)
        
        let imageFrame = imageView.frame
        let widthRatio = fullImageWidth / imageFrame.width
        let heightRatio = fullImageHeight / imageFrame.height
        
        // 이미지를 스케일 다운 시키기 위한 비율계산
        let scaleDownRatio = max(widthRatio, heightRatio)
        
        var imageWidth = fullImageWidth / scaleDownRatio
        var imageHeight = fullImageHeight / scaleDownRatio
        
        // TODO: - 다시 살펴보기 -> imageView의 leading constraint만큼 더해주어야 한다.
        let xLayer = (imageFrame.width - imageWidth) / 2 + 60
        let yLayer = imageView.frame.minY + (imageFrame.height - imageHeight) / 2

        let drawingLayer = CALayer()
        drawingLayer.bounds = CGRect(x: xLayer, y: yLayer, width: imageWidth, height: imageHeight)
        drawingLayer.anchorPoint = CGPoint.zero
        drawingLayer.position = CGPoint(x: xLayer, y: yLayer)
        drawingLayer.opacity = 1
        pathLayer = drawingLayer
        viewModel?.pathLayer = pathLayer
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

// MARK: - Drawing Element

extension FaceDetectController {
    
    fileprivate func boundingBox(forRegionOfInterest: CGRect, withInImageBounds bounds: CGRect) -> CGRect {
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        
        var rect = forRegionOfInterest
        
        rect.origin.x *= imageWidth
        rect.origin.x += bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y
        
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        
//        print(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
        
        return rect
    }
    
    fileprivate func shapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
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
}

// MARK: - FaceDetectViewModelDelegate

extension FaceDetectController: FaceDetectViewModeleDelegate {
    
    func drawFaceDetection(faces: [VNFaceObservation], onImageWithBounds bounds: CGRect) {
        guard let viewModel = viewModel else { return }
        CATransaction.begin()
        faces.forEach { observation in
            let faceBox = boundingBox(forRegionOfInterest: observation.boundingBox, withInImageBounds: bounds)
            let faceLayer = shapeLayer(color: .yellow, frame: faceBox)
            // TODO: - 얼굴이 9개인데 왜 그 이상으로 호출되지...? 흠...
    //            viewModel.addDetectInfo(with: self.currentImage, bound: bounds)
            pathLayer?.addSublayer(faceLayer)
            
        }
        CATransaction.commit()
        
        faces.forEach { observation in
            viewModel.addDetectInfo(with: self.currentImage, boundingBox: observation.boundingBox)
        }
    }
    
    func detectInfoDidChange() {
//        print(#function)
        guard let viewModel = viewModel else { return }
        let detectInfos = viewModel.detectInfos
        
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(detectInfos)
        detectDataSource?.apply(snapshot)
        
    }
}
