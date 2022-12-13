//
//  BarTextLayer.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/30.
//

import UIKit

final class BarTextLayer: CATextLayer {
    
    // MARK: - Properties
    
    private let rect: CGRect
    
    private let text: String
    
    private let textFontSize: CGFloat
    
    private let alignment: CATextLayerAlignmentMode?
    
    // MARK: - Init
    
    init(rect: CGRect, text: String, textFontSize: CGFloat, alignment: CATextLayerAlignmentMode? = nil) {
        self.rect = rect
        self.text = text
        self.textFontSize = textFontSize
        self.alignment = alignment
        
        super.init()
        
        configureFrame()
        configureText()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure Functions
    
    /// 표시할 텍스트 레이어의 위치, 크기를 지정한다.
    private func configureFrame() {
        frame = rect
    }
    
    /// 표시할 텍스트의 크기, 색상을 지정한다.
    private func configureText() {
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: textFontSize),
                .foregroundColor: UIColor.grey3 ?? UIColor()
            ]
        )
        string = attributedString
        alignmentMode = alignment ?? .center
        truncationMode = .end
    }
}
