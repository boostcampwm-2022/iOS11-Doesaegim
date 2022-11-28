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
        let date: Date?
        var isSelected: Bool = false
        var isSelectable: Bool = true
    }
    
    // MARK: - typealias
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: - Properties
    
    private var diffableDatasource: Datasource?
    private var today = Date()
    private var calendar = Calendar.current
    private var dateComponents = DateComponents()
    private let dateFormmater = Date.yearMonthDateFormatter
    private let weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    private var days: [Item] = []
    private let touchOption: TouchOption
    private var selectedCount = 0
    private var selectedDates: [Date] = []
    
    var completionHandler: (([Date]) -> Void)?
    
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
    
    @available(*, unavailable)
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
    
    private func configureDatasource() -> Datasource {
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
        var snapshot = Snapshot()
        snapshot.appendSections([.day])
        snapshot.appendItems(days, toSection: .day)
        diffableDatasource?.apply(snapshot)
    }
    
    // MARK: - Calendar Functions
    
    private func configureCalendar() {
        dateComponents.year = calendar.component(.year, from: today)
        dateComponents.month = calendar.component(.month, from: today)
        setupCalendar()
        configureSnapshot()
    }
    
    
    /// 캘린더 설정 함수
    private func setupCalendar() {
        /// 현재 Month의 1일이 무슨 요일인지 인덱스로 알려줌
        /// 0부터 월요일
        let firstWeekIndex = calendar.component(.weekday, from: today) - 1
        
        /// 마지막 날짜
        /// ex) 2월 - 28, 12월- 31
        let endOfday = calendar.range(of: .day, in: .month, for: today)?.count ?? 31
        
        /// 모든 날짜의 합을 알려줌
        /// ex) 2022년 11월  화요일 시작 (2) + 30일까지 있음 (30)
        /// totalDays = 32
        let totalDays = firstWeekIndex + endOfday
        
        days.removeAll()
        
        setSelectableDay(firstWeekIndex: firstWeekIndex, totalDays: totalDays)
        
    }
}

extension CustomCalendar {
    enum TouchOption {
        case single
        case double
    }
    
    enum CalendarType {
        case date
        case dateAndTime
    }
    
    /// 첫번째 날짜가 시작할 때 부터 숫자를 채워줌, 이전 날짜는 공백으로 처리
    /// - Parameters:
    ///   - firstWeekIndex: 현재 달의 1일의 요일 월요일(0)
    ///   - totalDays: 모든 날짜의 합
    private func setSelectableDay(firstWeekIndex: Int, totalDays: Int) {
        switch touchOption {
        case .single:
            break
            // TODO: 싱글 터치인 경우 기간 안에만 선택되도록
        case .double:
            guard let currentYear = dateComponents.year, let month = dateComponents.month else {
                return
            }
            let currentMonth = String(format: "%02d", month)
            for day in 0..<totalDays {
                if day < firstWeekIndex {
                    days.append(Item(date: nil, isSelectable: false))
                } else {
                    let currentDay = String(format: "%02d", day - firstWeekIndex + 1)
                    let stringDate = "\(currentYear)년 \(currentMonth)월 \(currentDay)일"
                    guard let date = Date.yearMonthDayDateFormatter.date(from: stringDate) else {
                        return
                    }
                    if let selectedDate = selectedDates.first {
                        let isSelectable = selectedDate <= date
                        days.append(Item(date: date,
                                         isSelected: selectedDate == date,
                                         isSelectable: isSelectable))
                    } else {
                        days.append(Item(date: date,
                                         isSelectable: true))
                    }
                    
                }
            }
        }
    }
}

// MARK: Calendar Cell Tapped

// TODO: 출발 날짜를 선택했을 때, 이전 날짜를 선택못하도록 막아야하는 것 구현해야됨!
extension CustomCalendar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let startDay = calendar.component(.weekday, from: today) - 1
        
        guard days[indexPath.row].isSelectable else { return }
        
        guard indexPath.row >= startDay,
              let currentYear = dateComponents.year,
              let month = dateComponents.month else { return }
        
        let currentMonth = String(format: "%02d", month)
        let currentDay = String(format: "%02d", indexPath.row - startDay + 1)
        let stringDate = "\(currentYear)년 \(currentMonth)월 \(currentDay)일"
        days[indexPath.row].isSelected.toggle()
        selectedCount += 1
        
        guard let date = Date.yearMonthDayDateFormatter.date(from: stringDate) else { return }
        selectedDates.append(date)
        
        switch touchOption {
        case .single:
            completionHandler?(selectedDates)
            selectedDates.removeAll()
            selectedCount = 0
            configureSnapshot()
            days = days.map { Item(date: $0.date, isSelected: false, isSelectable: $0.isSelectable) }
        case .double:
            if selectedCount == 1 {
                if let selectedDate = selectedDates.first {
                    days = days.map {
                        $0.date == nil ? Item(date: nil, isSelectable: false)
                        : Item(date: $0.date ?? Date(), isSelected: selectedDate == ($0.date ?? Date()),
                               isSelectable: selectedDate <= ($0.date ?? Date()))
                    }
                }
            } else if selectedCount == 2 {
                completionHandler?(selectedDates)
                selectedDates.removeAll()
                selectedCount = 0
                days = days.map { Item(date: $0.date, isSelected: false, isSelectable: true)}
            }
            configureSnapshot()
        }
    }
}
