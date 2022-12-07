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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let settingInfo = viewModel.settingInfos[safeIndex: indexPath.section],
              let info = settingInfo.options[safeIndex: indexPath.row] else { return }
        // TODO: - 핸들러 실행 또는 네비게이션 바 이동
        
    }
    
    
    
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settingInfos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let options = viewModel.settingInfos[safeIndex: section]?.options else { return 0 }
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let settingInfos = viewModel.settingInfos[safeIndex: indexPath.section],
              let info = settingInfos.options[safeIndex: indexPath.row],
              let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingTableViewCell.identifier,
                for: indexPath
              ) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: info)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let settingInfos = viewModel.settingInfos[safeIndex: section] else { return nil }
        return settingInfos.title
    }
}

struct SettingSection {
    let title: String
    let options: [SettingOptionViewModel]
}

