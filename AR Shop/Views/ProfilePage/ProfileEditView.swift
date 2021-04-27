//
//  ProfileEditView.swift
//  AR Shop
//
//  Created by Neel Mewada on 25/04/21.
//

import UIKit

class ProfileEditView: UIView {
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        configureView()
        viewModel.setUpdateCallback(self.viewModelDidChange)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        viewModel.setUpdateCallback(self.viewModelDidChange)
    }
    
    /// Use this function to make/push edits & changes to the viewModel
    func viewDidChange() {
        
    }
    
    /// Called when the viewModel is modified/set `externally`. Use this function to update data displayed by this view.
    func viewModelDidChange() {
        configureData()
    }
    
    // MARK: - Properties
    
    private let viewModel: ProfileEditViewModel = ProfileEditViewModel()
    
    private let topBar = GenericTopBar("Edit Profile")
    
    private lazy var fullnameField: GenericTextField = {
        let field = GenericTextField(title: "Full Name", contentType: .name)
        field.setEditingCallback { [weak self] text in
            self?.viewModel.fullName = text
        }
        return field
    }()
    
    private lazy var genderField: GenericPickerField = {
        let picker = GenericPickerField(title: "Gender", options: Gender.optionsArray)
        picker.setEditingCallback { [weak self] text in
            self?.viewModel.gender = Gender.init(rawValue: text) ?? .unspecified
        }
        return picker
    }()
    
    private lazy var phoneField: GenericTextField = {
        let field = GenericTextField(title: "Phone", contentType: .telephoneNumber)
        field.setEditingCallback { [weak self] text in
            self?.viewModel.phone = text
        }
        return field
    }()
    
    // MARK: - Actions
    
    @objc private func viewTapped() {
        self.endEditing(true)
        
        print("ProfileEditViewModel values: \(viewModel.fullName) ; \(viewModel.gender.rawValue)")
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = Constants.primaryBackgroundColor
        
        addSubview(topBar)
        topBar.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingBottom: -50)
        
        addSubview(fullnameField)
        fullnameField.anchor(top: topBar.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 25, paddingLeft: 30, paddingRight: 30)
        
        let stack1 = UIStackView()
        stack1.axis = .horizontal
        stack1.spacing = 20.0
        stack1.distribution = .fillEqually
        
        addSubview(stack1)
        stack1.anchor(top: fullnameField.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30)
        stack1.addArrangedSubview(genderField)
        stack1.addArrangedSubview(phoneField)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        
        configureData()
    }
    
    func configureData() {
        fullnameField.text = viewModel.fullName
        genderField.selectOption(with: viewModel.gender.rawValue)
        phoneField.text = viewModel.phone
    }
}
