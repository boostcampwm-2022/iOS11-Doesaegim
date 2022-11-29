//
//  FaceDetectProtocol.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/29.
//

import UIKit


protocol FaceDetectViewModelProtocol: AnyObject {
    
    var delegate: FaceDetectViewModeleDelegate? { get set }
    var pathLayer: CALayer? { get set }
    
}

protocol FaceDetectViewModeleDelegate: AnyObject {
    
    func FaceDetectLayerDidChange()
    
}
