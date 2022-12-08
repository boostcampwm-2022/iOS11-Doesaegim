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
    
    private let viewModel: CalendarSettingViewModelProtocol? = CalendarSettingViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel?.configureCalendarSettingInfos()
    }

}

extension CalendarSettingController {
    
    // MARK: - Configuration
    
    private func configure() {
        configureNavigationBar()
        configureTableView()
        configureSubviews()
        
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
    
    private func configureSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    @objc func didCompleteButtonTap() {
        print("완료버튼이 눌렸습니다~")
    }
    
}

extension CalendarSettingController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(indexPath) 셀 선택!")
        
        // 다른 것의 같은 섹션의 다른 표현을 false로 하고, 선택한 현재 열을 true로 한다.
        guard let viewModel = viewModel else { return }
        
    }
    
}

extension CalendarSettingController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.calendarSettingInfos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel,
              let infos = viewModel.calendarSettingInfos[safeIndex: section] else { return 0 }
        return infos.options.count
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
        
        let isSelected = (infos.selectedOption == indexPath.row)
        cell.configureData(with: info, isSelected: isSelected)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let viewModel = viewModel,
              let infos = viewModel.calendarSettingInfos[safeIndex: section] else { return nil }
        return infos.title
    }
}

extension CalendarSettingController: CalendarSettingViewModelDelegate {
    
    func calendarSettingDidChange() {
        tableView.reloadData()
    }
    
}
