//
//  SettingViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit

final class SettingViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
    }

}

extension SettingViewController {
    
    private func configure() {
        
        configureNavigationBar()
        configureTableView()
        configureSubviews()
        configureConstraints()
        
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "설정"
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    private func configureSubviews() {
        
    }
    
    private func configureConstraints() {
        
    }
    
    
    
}

extension SettingViewController: UITableViewDelegate {
    
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        return cell
    }
}
