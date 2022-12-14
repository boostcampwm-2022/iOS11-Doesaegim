//
//  SettingViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit
import SafariServices


final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingStaticCell.self, forCellReuseIdentifier: SettingStaticCell.name)
        table.register(SettingSwitchCell.self, forCellReuseIdentifier: SettingSwitchCell.name)
        
        return table
    }()
    
    private var viewModel: SettingViewModelProtocol = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.delegate = self
    }

}

extension SettingViewController {
    
    private func configure() {
        viewModel.configureSettingInfos()
        configureNavigationBar()
        configureTableView()
        configureSubviews()
        
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
    
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let settingInfo = viewModel.settingInfos[safeIndex: indexPath.section],
              let info = settingInfo.options[safeIndex: indexPath.row] else { return }
        // TODO: - 핸들러 실행 또는 네비게이션 바 이동
        
        switch info {
        case .staticCell(let model):
            model.handler()
            
        default:
            return
        }
        
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
              let info = settingInfos.options[safeIndex: indexPath.row] else {
            return UITableViewCell()
        }
        
        switch info {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingStaticCell.name,
                for: indexPath
            ) as? SettingStaticCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .switchCell(let model):
            // TODO: - SwitchCell 설정 알림설정 등
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingSwitchCell.name,
                for: indexPath
            ) as? SettingSwitchCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let settingInfos = viewModel.settingInfos[safeIndex: section] else { return nil }
        return settingInfos.title
    }
}

extension SettingViewController: SettingViewModelDelegate {
    
    func settingInquiryDidTap() {
        let alertAction = UIAlertAction(title: "확인", style: .default)
        
        presentAlert(
            title: "다음 이메일로 문의해주세요",
            message: "doesaegim2022@gmail.com",
            actions: alertAction
        )
    }
    
    func settingAlertDidTap() {
        let alertAction = UIAlertAction(title: "확인", style: .default)
        
        presentAlert(
            title: "아직 추가되지 않은 기능이에요!",
            message: "앞으로 추가될 예정입니다\n많은 응원부탁드려요 ☺️",
            actions: alertAction
        )
    }
    
    func settingViewCellDidTap(moveTo controller: UIViewController) {
        print(#function)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func settingPersonalInformationProcessingDidTap() {
        guard let url = URL(
            string: "https://sunny-side-up.notion.site/1d9f9efaceb5433abeeaf71c1f63b263"
        ) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
    
}
