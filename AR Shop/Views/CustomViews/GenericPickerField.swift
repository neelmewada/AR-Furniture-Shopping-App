//
//  GenericPickerField.swift
//  AR Shop
//
//  Created by Neel Mewada on 26/04/21.
//

import UIKit

class GenericPickerField: UIView {
    // MARK: - Lifecycle
    
    init(title: String, options: [String]) {
        self.selectOptions = options
        self.pickerView = PickerViewController(options: options)
        super.init(frame: .zero)
        titleLabel.text = title
        
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        self.selectOptions = []
        self.pickerView = PickerViewController(options: selectOptions)
        super.init(coder: coder)
        self.configureView()
    }
    
    // MARK: - Properties
    
    private var selectOptions: [String] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "Poppins-SemiBold", size: 13)
        return label
    }()
    
    private lazy var pickerButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 11)
        button.setTitleColor(Constants.primaryBlackColor, for: .normal)
        button.setTitleColor(Constants.primaryBlackColor, for: .highlighted)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(inputFieldTapped), for: .touchUpInside)
        let bottomLine = UIView()
        button.addSubview(bottomLine)
        bottomLine.backgroundColor = Constants.primaryGrayColor
        bottomLine.anchor(left: button.leftAnchor, bottom: button.bottomAnchor, right: button.rightAnchor, height: 1.0)
        return button
    }()
    
    private let pickerView: PickerViewController
    
    public var textLabel: UILabel {
        return titleLabel
    }
    
    private var editingChangedCallback: ((String) -> ())? = nil
        
    // MARK: - Actions
    
    @objc private func inputFieldTapped() {
        AppRuntime.presentModally(pickerView, animated: true)
    }
    
    private func editingChanged(_ text: String) {
        editingChangedCallback?(text)
        pickerButton.setTitle(text.capitalized, for: .normal)
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        addSubview(pickerButton)
        pickerButton.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, height: 20)
        pickerButton.setTitle(pickerView.getSelectedItem().capitalized, for: .normal)
        
        self.setHeight(height: 50)
    }
    
    func selectOption(with name: String, animated: Bool = true) {
        if let index = pickerView.options.firstIndex(of: name) {
            pickerView.picker.selectRow(index, inComponent: 0, animated: animated)
        }
    }
    
    func selectOption(with index: Int, animated: Bool = true) {
        pickerView.picker.selectRow(index, inComponent: 0, animated: animated)
    }
    
    func setEditingCallback(_ callback: @escaping (String) -> ()) {
        pickerView.setEditingCallback(editingChanged)
        self.editingChangedCallback = callback
    }
    
    
    // MARK: - PickerViewController
    
    class PickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
        // MARK: - Lifecycle
        
        init(options: [String]) {
            self.options = options
            super.init(nibName: nil, bundle: nil)
            self.configureViewController()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.configureViewController()
        }
        
        // MARK: - Properties
        
        fileprivate var options: [String] = []
        
        private var editingChangedCallback: ((String) -> ())? = nil
        
        private let contentView: UIView = {
            let view = UIView()
            view.backgroundColor = Constants.primaryBackgroundColor
            view.layer.cornerRadius = 6.0
            view.clipsToBounds = true
            return view
        }()
        
        public lazy var picker: UIPickerView = {
            let picker = UIPickerView()
            picker.overrideUserInterfaceStyle = .light
            picker.dataSource = self
            picker.delegate = self
            return picker
        }()
        
        // MARK: - Methods
        
        @objc private func viewTapped() {
            self.dismiss(animated: true)
        }
        
        func getSelectedItemIndex() -> Int {
            return picker.selectedRow(inComponent: 0)
        }
        
        func getSelectedItem() -> String {
            return options[getSelectedItemIndex()]
        }
        
        private func configureViewController() {
            view.backgroundColor = .clear
            
            view.addSubview(contentView)
            contentView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
            contentView.setHeight(height: 200)
            
            contentView.addSubview(picker)
            picker.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 25, paddingBottom: 25)
            
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        }
        
        public func setEditingCallback(_ callback: @escaping (String) -> ()) {
            self.editingChangedCallback = callback
        }
        
        // MARK: - UIPickerViewDataSource
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            options.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return options[row].capitalized
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.editingChangedCallback?(options[row])
        }
    }
}

