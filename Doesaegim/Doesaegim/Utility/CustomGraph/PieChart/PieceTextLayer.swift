//
//  PieceTextLayer.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/21.
//

import UIKit

final class PieceTextLayer: CATextLayer {
    
    // MARK: - Properties
    
    private let rect: CGRect
    
    private let text: String
    
    // MARK: - Init
    
    init(rect: CGRect, text: String) {
        self.rect = rect
        self.text = text
        
        super.init()
        
        configureText()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure Functions
    
    private func configureText() {
        string = text
        fontSize = 16
        alignmentMode = .center
        foregroundColor = UIColor.label.cgColor
        frame = rect
    }
}
