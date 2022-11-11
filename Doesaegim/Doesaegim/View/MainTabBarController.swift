//
//  ViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/10.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        let trevelPlanViewController = UINavigationController(rootViewController: TrevelPlanViewController())
        let expenseViewController = UINavigationController(rootViewController: ExpenseViewController())
        let mapViewController = UINavigationController(rootViewController: MapViewController())
        let diaryViewController = UINavigationController(rootViewController: DiaryViewController())
        let settingViewController = UINavigationController(rootViewController: SettingViewController())
        
        trevelPlanViewController.tabBarItem.image = UIImage(systemName: "calendar")
        expenseViewController.tabBarItem.image = UIImage(systemName: "dollarsign.circle")
        mapViewController.tabBarItem.image = UIImage(systemName: "map")
        diaryViewController.tabBarItem.image = UIImage(systemName: "doc.append")
        settingViewController.tabBarItem.image = UIImage(systemName: "gear")
        
        tabBar.tintColor = UIColor(named: "primaryOrange")
        
        trevelPlanViewController.title = "일정"
        expenseViewController.title = "지출 "
        mapViewController.title = "지도"
        diaryViewController.title = "다이어리"
        settingViewController.title = "설정"
        
        setViewControllers(
            [
                trevelPlanViewController,
                expenseViewController,
                mapViewController,
                diaryViewController,
                settingViewController
            ],
            animated: true
        )
        
    }

}
