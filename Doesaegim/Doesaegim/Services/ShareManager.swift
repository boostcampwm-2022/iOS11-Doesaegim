//
//  ShareManager.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/29.
//

import UIKit

final class ShareManager {
    static let shared: ShareManager = ShareManager()
    
    var documentController: UIDocumentInteractionController?
    
    private init() { }
    
    func shareToActivityViewController(with shareView: UIView, to viewController: UIViewController) {
        let renderer = UIGraphicsImageRenderer(size: shareView.bounds.size)
        let renderImage = renderer.image { _ in
            shareView.drawHierarchy(in: shareView.bounds, afterScreenUpdates: true)
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: [renderImage],
            applicationActivities: nil
        )
        activityViewController.excludedActivityTypes = [.saveToCameraRoll]
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        viewController.present(activityViewController, animated: true)
    }
    
    func shareToInstagramStory(with sharedView: UIView, to viewController: UIViewController) {
        guard let storyShareURL = URL(string: "instagram-stories://share") else {
            viewController.presentErrorAlert(title: "공유하기 기능을 사용할 수 없어요.")
            return
        }
        guard UIApplication.shared.canOpenURL(storyShareURL) else {
            viewController.presentErrorAlert(title: "인스타그램 앱을 설치하셔야 이용할 수 있어요.")
            return
        }
        let renderer = UIGraphicsImageRenderer(size: sharedView.bounds.size)
        
        let renderImage = renderer.image { _ in
            sharedView.drawHierarchy(in: sharedView.bounds, afterScreenUpdates: true)
        }
        guard let imageData = renderImage.pngData() else {
            viewController.presentErrorAlert(title: "공유할 수 없는 이미지 유형입니다.")
            return
        }
        
        let pasteboardItems: [String: Any] = [
            "com.instagram.sharedSticker.stickerImage": imageData,
            "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
            "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
        ]
        
        let pasteboardOptions = [
            UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
        ]
        
        UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
        UIApplication.shared.open(storyShareURL, options: [:], completionHandler: nil)
    }
    
}
