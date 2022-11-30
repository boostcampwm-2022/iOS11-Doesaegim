//
//  TempMosaicViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/30.
//

import UIKit

class TempMosaicViewController: UIViewController {

    private var image: UIImage?
    private var selectedFaces: [DetectInfoViewModel]?
    
    init(image: UIImage, selectedFaces: [DetectInfoViewModel]) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        self.selectedFaces = selectedFaces
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "임시 모자이크 뷰"
    }

}
