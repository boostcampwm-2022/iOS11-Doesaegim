//
//  PickerViewController.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/11/22.
//

import UIKit

import SnapKit

final class ExpenseAddPickerViewController: UIViewController, ExpenseAddPickerViewProtocol {
    
    // MARK: - UI properties
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font.withSize(15)
        label.textColor = .black
        label.textAlignment = .center
        label.text = type == .category ? "카테고리" : "화폐 단위"
        return label
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .primaryOrange
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return button
    }()
    
    // MARK: - Properties
    
    private var exchangeInfo: [ExchangeData] = ExchangeData.list
    private let exchangeDiskCache = ExchangeDiskCache.shared
    private let exchangeMemoryCache = ExchangeMemoryCache.shared
    
    // TODO: - category 항목이 정해지면 수정 Enum으로?
    
    private var category: [ExpenseType] = ExpenseType.allCases
    
    private let type: PickerType
    private var selectedIndex: Int = 0
    
    var delegate: ExpenseAddPickerViewDelegate?
    
    // MARK: - Lifecycles
    
    init(type: PickerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configureViews()
        setAddTargets()
        if type == .moneyUnit {
            Task {
                try await setExchangeValue()
            }
        }
    }
    
    // MARK: - Configure Functions
    
    private func configureViews() {
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSubviews() {
        view.addSubviews(contentView)
        contentView.addSubviews(pickerView, titleLabel, exitButton, addButton)
    }
    
    private func configureConstraints() {
        contentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.centerX.equalToSuperview()
        }
        
        exitButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.height.equalTo(25)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.bottom.equalTo(addButton.snp.top).offset(-20)
        }
        
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-30)
            $0.height.equalTo(48)
        }
    }
    
    // MARK: - Actions
    
    @objc func exitButtonTouchUpInside() {
        dismiss(animated: true)
    }
    
    @objc func addButtonTouchUpInside() {
        if type == .moneyUnit {
            guard selectedIndex < exchangeInfo.count else { return }
            delegate?.selectedExchangeInfo(item: exchangeInfo[selectedIndex])
        } else {
            delegate?.selectedCategory(item: category[selectedIndex])
        }
        dismiss(animated: true)
    }
    
    // MARK: - AddTarget
    
    private func setAddTargets() {
        exitButton.addTarget(self, action: #selector(exitButtonTouchUpInside), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTouchUpInside), for: .touchUpInside)
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(exitButtonTouchUpInside)
            ))
    }
    
    
    // MARK: - Network
    
    func fetchExchangeInfo(day: String) async throws {
        let network = NetworkManager(configuration: .default)
        var paramaters: [String: String] = [:]
        paramaters["authkey"] = ExchangeAPI.authkey
        paramaters["data"] = ExchangeAPI.dataCode
        paramaters["searchdate"] = day
        
        let resource = Resource<ExchangeResponse>(
            base: ExchangeAPI.exchangeURL,
            paramaters: paramaters,
            header: [:])
        
        let result = try await network.loadArray(resource)
        
        switch result {
        case .success(let response):
            if response.isEmpty {
                try await fetchExchangeInfo(day: Date.yesterDayDateConvertToString())
            } else {
                exchangeInfo = response.map { ExchangeData(
                    currencyCode: $0.currencyCode,
                    tradingStandardRate: $0.tradingStandardRate,
                    currencyName: $0.currencyName
                )}
                pickerView.reloadAllComponents()
                UserDefaults.standard.set(day, forKey: Constants.fetchExchangeInfoDate)
                exchangeDiskCache.saveExchangeRateInfo(exchangeInfo: response)
            }
        case .failure(let error):
            if let info = exchangeDiskCache.fetchExchangeRateInfo() {
                exchangeInfo = info.map { ExchangeData(
                    currencyCode: $0.currencyCode,
                    tradingStandardRate: $0.tradingStandardRate,
                    currencyName: $0.currencyName
                )}
            }
            print(error.localizedDescription)
        }
    }
    
    // MARK: UserDefaults
    
    private func setExchangeValue() async throws {
        // UserDefault 확인
        if let fetchExchangeInfoDate = UserDefaults.standard.string(forKey: Constants.fetchExchangeInfoDate) {
            
            // 메모리 캐시에 값 있는지 확인
            let cacheKey = NSString(string: fetchExchangeInfoDate)
            if let cachedExchangeRateInfo = exchangeMemoryCache.object(forKey: cacheKey)
                as? [ExchangeResponse] {
                exchangeInfo = cachedExchangeRateInfo.map {
                    ExchangeData(
                        currencyCode: $0.currencyCode,
                        tradingStandardRate: $0.tradingStandardRate,
                        currencyName: $0.currencyName
                    )
                }
                pickerView.reloadAllComponents()
                print("[MemoryCache] Hit")
                return
            }
            
            // UserDefault의 저장된 날짜가 오늘 날짜와 같고, 디스크 캐시에 저장되어 있다면
            // 디스크 캐시에서 불러옴
            // 메모리 캐시에 저장
            if fetchExchangeInfoDate == Date.todayDateConvertToString(),
               let info = exchangeDiskCache.fetchExchangeRateInfo() {
                exchangeInfo = info.map {
                    ExchangeData(
                        currencyCode: $0.currencyCode,
                        tradingStandardRate: $0.tradingStandardRate,
                        currencyName: $0.currencyName
                    )
                }
                print("[DiskCache] Hit")
                pickerView.reloadAllComponents()
                
                let cacheKey = NSString(string: fetchExchangeInfoDate)
                exchangeMemoryCache.setObject(info as NSArray, forKey: cacheKey)
            } else {
                // 날짜가 다르면 오늘 날짜로 api 요청
                try await fetchExchangeInfo(day: Date.todayDateConvertToString())
            }
            
        } else {
            // 없으면 api 요청
            try await fetchExchangeInfo(day: Date.todayDateConvertToString())
        }
    }
}

extension ExpenseAddPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return type == .moneyUnit ? exchangeInfo.count : category.count
    }
}

extension ExpenseAddPickerViewController: UIPickerViewDelegate {
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        if type == .moneyUnit {
            let value = exchangeInfo.map {
                let exchangeRateType = ExchangeRateType(currencyCode: $0.currencyCode) ?? .AED
                let icon = exchangeRateType.icon
                return "\(icon) \($0.currencyName)"
            }
            return value[row]
        } else {
            return category[row].rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
}

// MARK: Enum

extension ExpenseAddPickerViewController {
    enum PickerType {
        case category
        case moneyUnit
    }
}
