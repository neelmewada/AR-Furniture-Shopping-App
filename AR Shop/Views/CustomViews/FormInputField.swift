//
//  FormInputField.swift
//  AR Shop
//
//  Created by Neel Mewada on 22/04/21.
//

import UIKit


/// Custom InputField used for Login and Registration Form
class FormInputField: UIView {
    // MARK: - Lifecycle
    
    init(title: String, contentType: UITextContentType, isRequired: Bool = true, isSecure: Bool = false) {
        super.init(frame: .zero)
        self.isRequired = isRequired
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .fromHex("353636")
        label.font = UIFont(name: "Poppins-SemiBold", size: 15)
        return label
    }()
    
    private lazy var inputField: TextField = {
        let field = TextField()
        field.layer.cornerRadius = 8.0
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.fromHex("C3C3C3").cgColor
        field.font = UIFont(name: "Poppins-SemiBold", size: 15)
        field.textColor = .black
        field.addTarget(self, action: #selector(onInputFieldEdit), for: .editingChanged)
        return field
    }()
    
    public var textLabel: UILabel {
        return titleLabel
    }
    
    public var textField: UITextField {
        return inputField
    }
    
    private var isRequired: Bool = true
    
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
        inputField.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, height: 44)
        
        self.setHeight(height: 70)
    }
    
    public func setEditingCallback(_ callback: @escaping (String) -> ()) {
        self.editingChangedCallback = callback
    }
    
    // MARK: - Custom UITextField
    
    class TextField: UITextField {
        let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
        override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
        override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
    }
}
