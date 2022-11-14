//
//  TravelPlanViewController.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/11/11.
//

import UIKit
import SnapKit

// TODO: - 클래스 이름 TravelListViewController로 바꾸면 좋을듯함...

final class TravelPlanViewController: UIViewController {

    
    private let placeholdLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 여행을 떠나볼까요?"
        label.textColor = .grey2
        
        return label
    }()
    
    private lazy var planCollectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .primaryOrange
        return collectionView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        configureSubviews()
        configureConstraints()
        configureNavigationBar()
    }
    
    // MARK: - Configure
    
    func configureSubviews() {
        view.addSubview(placeholdLabel)
        view.addSubview(planCollectionView)
    }
    
    func configureConstraints() {
        
        placeholdLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        planCollectionView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.snp.leading).offset(16)
            $0.trailing.equalTo(view.snp.trailing).offset(-16)
        }
        
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.tintColor = .primaryOrange
        navigationItem.title = "여행 목록"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didAddTravelButtonTap)
        )
    }
    
    // MARK: - Configure CollectionView
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) ->
            NSCollectionLayoutSection  in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 6)
            
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        return layout
    }
    
    // MARK: - Actions
    
    @objc func didAddTravelButtonTap() {
        print("여행 추가 버튼이 탭 되었습니다.")
    }
    

}
