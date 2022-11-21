//
//  CustomGraphViewController.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/17.
//

import UIKit

import SnapKit

class CustomGraphViewController: UISearchController {

    let rootView = SampleCustomGraphView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
