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
    private let viewModel: ExpenseAddPickerViewModel
    private let type: PickerType
    
    var delegate: ExpenseAddPickerViewDelegate?
    
    // MARK: - Lifecycles
    
    init(type: PickerType) {
        self.type = type
        viewModel = ExpenseAddPickerViewModel(type: type)
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
        viewModel.delegate = self
        UserDefaults.standard.removeObject(forKey: Constants.fetchExchangeInfoDate)
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
            guard viewModel.selectedIndex < viewModel.exchangeInfos.count else { return }
            delegate?.selectedExchangeInfo(item: viewModel.exchangeInfos[viewModel.selectedIndex])
        } else {
            delegate?.selectedCategory(item: viewModel.categories[viewModel.selectedIndex])
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
    
    private func setExchangeValue() async throws {
        try await viewModel.setExchangeValue()
    }
}

extension ExpenseAddPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRowsInComponents()
    }
}

extension ExpenseAddPickerViewController: UIPickerViewDelegate {
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return viewModel.pickerView(titleForRow: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.pickerView(didSelectRow: row)
    }
}

// MARK: ViewModel Delegate Functions

extension ExpenseAddPickerViewController: ExpenseAddPickerViewModelDelegate {
    func didChangeExchangeInfo() {
        DispatchQueue.main.async {
            self.viewModel.exchangeInfos.forEach { print("$$", $0.tradingStandardRate) }
            self.pickerView.reloadAllComponents()
        }
    }
    
    func didSelectedRow() {
        print("\(#function)")
    }
}

// MARK: Enum

extension ExpenseAddPickerViewController {
    enum PickerType {
        case category
        case moneyUnit
    }
}
