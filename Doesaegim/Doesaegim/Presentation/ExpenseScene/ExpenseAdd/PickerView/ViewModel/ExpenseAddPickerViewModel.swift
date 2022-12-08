//
//  ExpenseAddPickerViewModel.swift
//  Doesaegim
//
//  Created by 김민석 on 2022/12/08.
//

import Foundation

final class ExpenseAddPickerViewModel: ExpenseAddPickerViewModelProtocol {
    
    // MARK: - Properties
    
    weak var delegate: ExpenseAddPickerViewModelDelegate?
    
    private let repository: ExchangeRemoteRepository
    private let exchangeDiskCache = ExchangeDiskCache.shared
    private let exchangeMemoryCache = ExchangeMemoryCache.shared
    
    private let type: ExpenseAddPickerViewController.PickerType
    
    var exchangeInfos: [ExchangeData] {
        didSet {
            delegate?.didChangeExchangeInfo()
        }
    }
    var categories: [ExpenseType] = ExpenseType.allCases
    
    var numberOfComponents: Int = 1
    var selectedIndex: Int = 0 {
        didSet {
            delegate?.didSelectedRow()
        }
    }
    
    // MARK: - Lifecycles
    init(type: ExpenseAddPickerViewController.PickerType) {
        self.type = type
        repository = ExchangeRemoteRepository()
        exchangeInfos = ExchangeData.list
    }
    
    
    // MARK: - Helpers
    
    func fetchExchangeData(day: String) async throws {
        let result = try await repository.fetchExchangeData(day: day)
        switch result {
        case .success(let response):
            if response.isEmpty {
                try await fetchExchangeData(day: Date.yesterDayDateConvertToString())
            } else {
                exchangeInfos = response.map { ExchangeData(
                    currencyCode: $0.currencyCode,
                    tradingStandardRate: $0.tradingStandardRate,
                    currencyName: $0.currencyName
                )}
                UserDefaults.standard.set(day, forKey: Constants.fetchExchangeInfoDate)
                exchangeDiskCache.saveExchangeRateInfo(exchangeInfo: response)
            }
        case .failure(let error):
            if let info = exchangeDiskCache.fetchExchangeRateInfo() {
                exchangeInfos = info.map { ExchangeData(
                    currencyCode: $0.currencyCode,
                    tradingStandardRate: $0.tradingStandardRate,
                    currencyName: $0.currencyName
                )}
            }
            print(error.localizedDescription)
        }
    }
    
    func setExchangeValue() async throws {
        // UserDefault 확인
        if let fetchExchangeInfoDate = UserDefaults.standard.string(forKey: Constants.fetchExchangeInfoDate) {
            
            // 메모리 캐시에 값 있는지 확인
            let cacheKey = NSString(string: fetchExchangeInfoDate)
            if let cachedExchangeRateInfo = exchangeMemoryCache.object(forKey: cacheKey)
                as? [ExchangeResponse] {
                exchangeInfos = cachedExchangeRateInfo.map {
                    ExchangeData(
                        currencyCode: $0.currencyCode,
                        tradingStandardRate: $0.tradingStandardRate,
                        currencyName: $0.currencyName
                    )
                }
                return
            }
            
            // UserDefault의 저장된 날짜가 오늘 날짜와 같고, 디스크 캐시에 저장되어 있다면
            // 디스크 캐시에서 불러옴
            // 메모리 캐시에 저장
            if fetchExchangeInfoDate == Date.todayDateConvertToString(),
               let info = exchangeDiskCache.fetchExchangeRateInfo() {
                exchangeInfos = info.map {
                    ExchangeData(
                        currencyCode: $0.currencyCode,
                        tradingStandardRate: $0.tradingStandardRate,
                        currencyName: $0.currencyName
                    )
                }
                let cacheKey = NSString(string: fetchExchangeInfoDate)
                exchangeMemoryCache.setObject(info as NSArray, forKey: cacheKey)
            } else {
                // 날짜가 다르면 오늘 날짜로 api 요청
                try await fetchExchangeData(day: Date.todayDateConvertToString())
            }
            
        } else {
            // 없으면 api 요청
            try await fetchExchangeData(day: Date.todayDateConvertToString())
        }
    }
    
    func numberOfRowsInComponents() -> Int {
        return type == .moneyUnit ? exchangeInfos.count : categories.count
    }
    
    func pickerView(titleForRow row: Int) -> String {
        if type == .moneyUnit {
            let value = exchangeInfos.map {
                let exchangeRateType = ExchangeRateType(currencyCode: $0.currencyCode) ?? .AED
                let icon = exchangeRateType.icon
                return "\(icon) \($0.currencyName)"
            }
            return value[row]
        } else {
            return categories[row].rawValue
        }
    }
    
    func pickerView(didSelectRow row: Int) {
        selectedIndex = row
    }
}
