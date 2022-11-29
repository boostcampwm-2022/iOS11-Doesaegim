//
//  ShareManager.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/29.
//

import UIKit

final class ShareManager {
    static let shared: ShareManager = ShareManager()
    
    private init() { }
    
    func instaStoryShare(sharedView: UIView) {
        guard let storyShareURL = URL(string: "instagram-stories://share") else {
            print("URL Error")
            return
        }
        if UIApplication.shared.canOpenURL(storyShareURL) {
            let renderer = UIGraphicsImageRenderer(size: sharedView.bounds.size)
            
            let renderImage = renderer.image { _ in
                sharedView.drawHierarchy(in: sharedView.bounds, afterScreenUpdates: true)
            }
            guard let imageData = renderImage.pngData() else { return }
            
            let pasteboardItems: [String: Any] = [
                "com.instagram.sharedSticker.stickerImage": imageData,
                "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3",
            ]
            
            let pasteboardOptions = [
                UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
            ]
            
            UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
            UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
        } else {
            print("can't open")
        }
    }
}
