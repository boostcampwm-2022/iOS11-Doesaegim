//
//  SettingViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
        return table
    }()
    
    private let viewModel: SettingViewModelProtocol = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

extension SettingViewController {
    
    private func configure() {
        viewModel.configureSettingInfos()
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
        view.addSubview(tableView)
    }
    
    private func configureConstraints() {
        
    }
    
    
    
}

extension SettingViewController: UITableViewDelegate {
    
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let settingInfo = viewModel.settingInfos[safeIndex: indexPath.row],
              let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.identifier,
                for: indexPath
              ) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: settingInfo)
        return cell
    }
}
