//
//  RegisterView.swift
//  AR Shop
//
//  Created by Neel Mewada on 22/04/21.
//

import UIKit

class RegisterView: UIView, ProfileViewProtocol {
    // MARK: - Lifecycle
    
    init(pageHandler: ProfilePageHandler?) {
        self.changePageHandler = pageHandler
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
    
    private let viewModel: RegisterViewModel = RegisterViewModel()
    private var changePageHandler: ProfilePageHandler? = nil
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()
    
    private let titleText: UILabel = {
        let label = UILabel()
        label.text = "Create an Account"
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 28)
        return label
    }()
    
    private let subtitleText: UILabel = {
        let label = UILabel()
        label.text = "Enter your details below."
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Medium", size: 17)
        return label
    }()
    
    private lazy var emailField: FormInputField = {
        let field = FormInputField(title: "Email Address*", contentType: .emailAddress)
        field.setEditingCallback { [weak self] text in
            self?.viewModel.emailAddress = text
        }
        return field
    }()
    
    private lazy var fullNameField: FormInputField = {
        let field = FormInputField(title: "Full Name*", contentType: .name)
        field.setEditingCallback { [weak self] text in
            self?.viewModel.fullName = text
        }
        return field
    }()
    
    private lazy var passwordField: FormInputField = {
        let field = FormInputField(title: "Password*", contentType: .password, isSecure: true)
        field.setEditingCallback { [weak self] text in
            self?.viewModel.password = text
        }
        return field
    }()
    
    private lazy var confirmPasswordField: FormInputField = {
        let field = FormInputField(title: "Confirm Password*", contentType: .password, isSecure: true)
        field.setEditingCallback { [weak self] text in
            self?.viewModel.confirmPassword = text
        }
        return field
    }()
    
    private lazy var registerButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Register", for: .normal)
        button.setPressedHandler(self.onRegisterButtonPressed)
        return button
    }()
    
    private lazy var loginPageButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.attributedTitle(firstPart: "Have an Account? ", secondPart: "LOGIN")
        button.addTarget(self, action: #selector(onLoginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var spinner: UIActivityIndicatorView? = nil
    
    private lazy var loadingView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .light)
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        self.spinner = UIActivityIndicatorView(style: .large)
        spinner!.color = .darkGray
        view.contentView.addSubview(spinner!)
        spinner!.center(inView: view.contentView)
        spinner!.setDimensions(height: 40, width: 40)
        return view
    }()
    
    // MARK: - Actions
    
    private func onRegisterButtonPressed() {
        if viewModel.registerUser(self.onUserRegistered) {
            loadingView.isHidden = false
            self.spinner?.startAnimating()
        }
    }
    
    @objc private func onLoginButtonPressed() {
        changePageHandler?(.loginPage)
    }
    
    private func onUserRegistered(_ error: Error?) {
        loadingView.isHidden = true
        if let error = error {
            AppRuntime.showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        changePageHandler?(.userPage)
    }
    
    func viewDidAppear() {
        
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30)
        
        stackView.addArrangedSubview(titleText)
        stackView.setCustomSpacing(10, after: titleText)
        
        stackView.addArrangedSubview(subtitleText)
        stackView.setCustomSpacing(50, after: subtitleText)
        
        stackView.addArrangedSubview(emailField)
        stackView.setCustomSpacing(25, after: emailField)
        
        stackView.addArrangedSubview(fullNameField)
        stackView.setCustomSpacing(25, after: fullNameField)
        
        stackView.addArrangedSubview(passwordField)
        stackView.setCustomSpacing(25, after: passwordField)
        
        stackView.addArrangedSubview(confirmPasswordField)
        stackView.setCustomSpacing(40, after: confirmPasswordField)
        
        stackView.addArrangedSubview(registerButton)
        registerButton.setHeight(height: 54)
        stackView.setCustomSpacing(30, after: registerButton)
        
        stackView.addArrangedSubview(loginPageButton)
        stackView.setCustomSpacing(25, after: loginPageButton)
        
        addSubview(loadingView)
        loadingView.center(inView: self)
        loadingView.setDimensions(height: 120, width: 120)
        loadingView.isHidden = true
        
        self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    }
    
    public func configureData() {
        
    }
}
