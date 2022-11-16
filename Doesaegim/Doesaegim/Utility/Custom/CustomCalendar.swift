//
//  CustomCalendar.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/15.
//

import UIKit

final class CustomCalendar: UICollectionView {
    
    // MARK: - Enum
    enum Section {
        case day
    }
    
    struct Item: Hashable {
        let id = UUID()
        let day: String
        var isSelected: Bool = false
    }
    
    // MARK: - Properties
    
    private var diffableDatasource: UICollectionViewDiffableDataSource<Section, Item>?
    private var today = Date()
    private var calendar = Calendar.current
    private var dateComponents = DateComponents()
    private var dateFormmater = DateFormatter()
    private let weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    private var days: [Item] = []
    private let touchOption: TouchOption
    private var selectedCount = 0
    private var selectedDates: [String] = []
    
    var completionHandler: (([String]) -> Void)?
    
    // MARK: - Lifecycles
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, touchOption: TouchOption) {
        self.touchOption = touchOption
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        configureCollectionView()
        diffableDatasource = configureDatasource()
        configureCalendar()
        configureSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Confugure Functions
    
    private func configureCollectionView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderColor = UIColor.primaryOrange?.cgColor
        layer.borderWidth = 1
        
        isScrollEnabled = false
        
        register(CustomCalendarCell.self, forCellWithReuseIdentifier: CustomCalendarCell.identifier)
        register(
            CustomCalendarHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CustomCalendarHeaderView.identifier
        )
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/7),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/6)
        )
        
        item.contentInsets = .init(top: 0, leading: 2, bottom: 0, trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDatasource() -> UICollectionViewDiffableDataSource<Section, Item>? {
        let datasource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: self,
            cellProvider: { collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CustomCalendarCell.identifier,
                    for: indexPath
                ) as? CustomCalendarCell else { return UICollectionViewCell() }
                
                cell.configureUI(item: item)
                return cell
            })
        
        datasource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self, kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomCalendarHeaderView.identifier,
                for: indexPath
            ) as? CustomCalendarHeaderView else { return UICollectionReusableView() }
            
            header.configureUI(date: self.dateFormmater.string(from: self.today), weeks: self.weeks)
            
            header.buttonHandler = { index in
                self.today = self.calendar.date(
                    byAdding: DateComponents(month: index),
                    to: self.today) ?? Date()
                self.configureCalendar()
                header.configureUI(date: self.dateFormmater.string(from: self.today), weeks: self.weeks)
            }
            
            return header
        }
        return datasource
    }
    
    private func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.day])
        snapshot.appendItems(days, toSection: .day)
        diffableDatasource?.apply(snapshot)
    }
    
    // MARK: - Calendar Functions
    
    private func configureCalendar() {
        dateComponents.year = calendar.component(.year, from: today)
        dateComponents.month = calendar.component(.month, from: today)
        dateFormmater.dateFormat = "yyyy년 MM월"
        setupCalendar()
        configureSnapshot()
    }
    
    private func setupCalendar() {
        let firstWeekIndex = calendar.component(.weekday, from: today) - 1
        let endOfday = calendar.range(of: .day, in: .month, for: today)?.count ?? 31
        
        let totalDays = firstWeekIndex + endOfday
        days.removeAll()
        for day in 0..<totalDays {
            if day < firstWeekIndex {
                days.append(Item(day: ""))
            } else {
                days.append(Item(day: "\(day - firstWeekIndex + 1)"))
            }
        }
        
    }
}

extension CustomCalendar {
    enum TouchOption {
        case single
        case double
    }
    
    private func setTouchOption(option: TouchOption) {
        
    }
}

// MARK: Calendar Cell Tapped

extension CustomCalendar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let startDay = calendar.component(.weekday, from: today) - 1
        
        guard indexPath.row >= startDay,
              let currentYear = dateComponents.year,
              let month = dateComponents.month else { return }
        
        let currentMonth = String(format: "%02d", month)
        let currentDay = String(format: "%02d", indexPath.row - startDay + 1)
        let date = "\(currentYear)-\(currentMonth)-\(currentDay)"
        days[indexPath.row].isSelected.toggle()
        selectedCount += 1
        
        selectedDates.append(date)
        
        switch touchOption {
        case .single:
            // TODO: 싱글터치일 때 작성
            return
        case .double:
            if selectedCount == 2 {
                completionHandler?(selectedDates)
                selectedDates.removeAll()
                selectedCount = 0
                for index in 0..<days.count {
                    days[index].isSelected = false
                }
            }
        }
        
        configureSnapshot()
    }

}
