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
    var boundingBoxes: [CGRect] { get set }
    var pathLayer: CALayer? { get set }
    var image: UIImage? { get set }
    
    func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation)
    
}

protocol FaceDetectViewModeleDelegate: AnyObject {
    
    func drawFaceDetection(faces: [VNFaceObservation], onImageWithBounds bounds: CGRect)
    
}
