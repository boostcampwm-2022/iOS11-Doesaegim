//
//  CalendarViewController.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/17.
//

import UIKit

import SnapKit

final class CalendarViewController: UIViewController, CalendarProtocol {
    
    // MARK: - UI properties
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var calendarView: CustomCalendar = {
        let calendar = CustomCalendar(
            frame: .zero,
            collectionViewLayout: CustomCalendar.createLayout(),
            touchOption: touchOption
        )
        
        calendar.completionHandler = { [weak self] dates in
            guard let self, dates.count == 1 else { return }
            switch self.touchOption {
            case .single:
                self.date = dates.first
                self.completeButton.isEnabled = true
                self.completeButton.backgroundColor = .primaryOrange
            case .double:
                // TODO: Double 모드일 때 작성
                return
            }
        }
        return calendar
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        let title = type == .date ? "날짜 추가" : "날짜 및 시간 추가"
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .grey3
        button.isEnabled = false
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var timeDatepicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.preferredDatePickerStyle = .compact
        datePicker.isHidden = type == .date
        return datePicker
    }()
    
    // MARK: - Properties
    
    weak var delegate: CalendarViewDelegate?
    private var date: Date?
    private let touchOption: CustomCalendar.TouchOption
    private let type: CustomCalendar.CalendarType
    private let dateFormatter = Date.timeDateFormatter
    
    
    // MARK: - Lifecycles
    
    init(touchOption: CustomCalendar.TouchOption, type: CustomCalendar.CalendarType) {
        self.touchOption = touchOption
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        completeButton.addTarget(self, action: #selector(completeButtonTouchUpInside), for: .touchUpInside)
        configureViews()
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraint()
    }
    
    private func configureSubviews() {
        view.addSubview(contentView)
        contentView.addSubviews(stackView, completeButton)
        stackView.addArrangedSubviews(calendarView,timeDatepicker)
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
//            $0.height.equalTo(600)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(completeButton.snp.top).offset(-20)
        }
        
        calendarView.snp.makeConstraints {
            $0.height.equalTo(400)
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-30)
            $0.height.equalTo(48)
        }
    }
}

// MARK: - Action

extension CalendarViewController {
    @objc func completeButtonTouchUpInside() {
        guard let date else {
            return
        }
        if type == .dateAndTime {
            let time = dateFormatter.string(from: timeDatepicker.date)
            let dateString = "\(Date.yearMonthDayDateFormatter.string(from: date)) \(time)"
            delegate?.fetchDate(dateString: dateString)
        } else { delegate?.fetchDate(dateString: Date.yearMonthDayDateFormatter.string(from: date)) }
        dismiss(animated: true)
            
    }
}
