//
//  PieceTextLayer.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/21.
//

import UIKit

final class PieceTextLayer: CATextLayer {
    
    // MARK: - Properties
    
    private let pieceBounds: CGRect
    
    private let text: String
    
    // MARK: - Init
    
    init(pieceBounds: CGRect, text: String) {
        self.pieceBounds = pieceBounds
        self.text = text
        
        super.init()
        
        configureFrame()
        configureText()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure Functions
    
    private func configureFrame() {
        let textFrame = CGRect(
            x: pieceBounds.minX + pieceBounds.width * 0.15,
            y: pieceBounds.minY + pieceBounds.height * 0.25,
            width: pieceBounds.width/1.5,
            height: pieceBounds.height/2
        )
        frame = textFrame
    }
    
    private func configureText() {
        string = text
        fontSize = Metric.textFontSize
        alignmentMode = .center
        foregroundColor = UIColor.white?.cgColor
    }
}

extension PieceTextLayer {
    enum Metric {
        static let textFontSize: CGFloat = 16
    }
}
