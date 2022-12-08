//
//  CalendarSettingController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/08.
//

import UIKit


final class CalendarSettingController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        
        table.register(CalendarSettingCell.self, forCellReuseIdentifier: CalendarSettingCell.name)
        
        return table
    }()
    
    private let viewModel: CalendarSettingViewModel? = CalendarSettingViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

extension CalendarSettingController {
    
    // MARK: - Configuration
    
    private func configure() {
        configureNavigationBar()
        configureSubview()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "날짜/시간표시"
        
        let completeButton = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(didCompleteButtonTap)
        )
        navigationItem.rightBarButtonItem = completeButton
        navigationController?.navigationBar.tintColor = .primaryOrange
    }
    
    private func configureSubview() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func didCompleteButtonTap() {
        print("완료버튼이 눌렸습니다~")
    }
    
}

extension CalendarSettingController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath) 셀 선택!")
    }
    
}

extension CalendarSettingController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let infos = viewModel.calendarSettingInfos[safeIndex: indexPath.section],
              let info = infos.options[safeIndex: indexPath.row],
              let cell = tableView.dequeueReusableCell(
                withIdentifier: CalendarSettingCell.name,
                for: indexPath
              ) as? CalendarSettingCell else {
            return UITableViewCell()
        }
        
        cell.configureData(with: info)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let viewModel = viewModel,
              let infos = viewModel.calendarSettingInfos[safeIndex: section] else { return nil }
        return infos.title
    }
}
