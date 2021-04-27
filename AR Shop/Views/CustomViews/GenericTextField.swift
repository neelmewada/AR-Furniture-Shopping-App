//
//  GenericInputField.swift
//  AR Shop
//
//  Created by Neel Mewada on 25/04/21.
//

import UIKit

class GenericTextField: UIView {
    // MARK: - Lifecycle
    
    init(title: String, contentType: UITextContentType, isSecure: Bool = false, textFieldHeight: CGFloat = 20) {
        super.init(frame: .zero)
        self.textFieldHeight = textFieldHeight
        titleLabel.text = title
        inputField.textContentType = contentType
        inputField.isSecureTextEntry = isSecure
        
        switch contentType {
        case .emailAddress:
            inputField.keyboardType = .emailAddress
            inputField.autocapitalizationType = .none
        case .name:
            inputField.autocorrectionType = .no
        case .URL:
            inputField.keyboardType = .URL
            inputField.autocorrectionType = .no
            inputField.autocapitalizationType = .none
        case .telephoneNumber:
            inputField.keyboardType = .phonePad
        default:
            inputField.keyboardType = .default
        }
        
        if contentType == .password || isSecure {
            inputField.autocorrectionType = .no
            inputField.spellCheckingType = .no
        }
        
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    // MARK: - Properties
    
    private var textFieldHeight: CGFloat = 20.0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "Poppins-SemiBold", size: 13)
        return label
    }()
    
    private lazy var inputField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.font = UIFont(name: "Poppins-Medium", size: 11)
        field.textColor = Constants.primaryBlackColor
        field.addTarget(self, action: #selector(onInputFieldEdit), for: .editingChanged)
        let bottomLine = UIView()
        field.addSubview(bottomLine)
        bottomLine.backgroundColor = Constants.primaryGrayColor
        bottomLine.anchor(left: field.leftAnchor, bottom: field.bottomAnchor, right: field.rightAnchor, height: 1.0)
        return field
    }()
    
    public var textLabel: UILabel {
        return titleLabel
    }
    
    public var textField: UITextField {
        return inputField
    }
    
    public var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    private var editingChangedCallback: ((String) -> ())?
    
    // MARK: - Actions
    
    @objc private func onInputFieldEdit() {
        editingChangedCallback?(inputField.text ?? "")
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        
        addSubview(inputField)
        inputField.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 5, height: textFieldHeight)
        
        self.setHeight(height: 30 + textFieldHeight)
    }
    
    public func setEditingCallback(_ callback: @escaping (String) -> ()) {
        self.editingChangedCallback = callback
    }
}
