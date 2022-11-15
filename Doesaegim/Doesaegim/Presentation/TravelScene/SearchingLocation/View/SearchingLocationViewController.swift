//
//  SearchingLocationViewController.swift
//  Doesaegim
//
//  Created by 서보경 on 2022/11/15.
//

import UIKit

final class SearchingLocationViewController: UIViewController {
    // MARK: - UI Properties
    
    private let rootView = SearchingLocationView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        view = rootView
        title = "장소 검색"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
