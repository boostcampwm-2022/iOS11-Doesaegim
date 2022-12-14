//
//  FaceDetectProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/29.
//

import UIKit
import Vision


protocol FaceDetectViewModelProtocol: AnyObject {
    
    var delegate: FaceDetectViewModeleDelegate? { get set }
    var detectInfos: [DetectInfoViewModel] { get set }
    var pathLayer: CALayer? { get set }
    var image: UIImage? { get set }
    
    func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation)
    func cropImage(of image: UIImage?, with cropRect: CGRect) -> UIImage?
    func addDetectInfo(with image: UIImage?, downsampledImage: UIImage?, boundingBox: CGRect)
}

protocol FaceDetectViewModeleDelegate: AnyObject {
    
    func drawFaceDetection(faces: [VNFaceObservation], onImageWithBounds bounds: CGRect)
    func detectInfoDidChange()
    func faceDetectDidFail()
    func faceDetectCountZero()
    
}
