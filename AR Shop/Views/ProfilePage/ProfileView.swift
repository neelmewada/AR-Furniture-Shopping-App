//
//  ProfileView.swift
//  AR Shop
//
//  Created by Neel Mewada on 24/04/21.
//

import UIKit

class ProfileView: UIView, ProfileViewProtocol {
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
    
    private let viewModel: ProfileViewModel = ProfileViewModel()
    private var changePageHandler: ProfilePageHandler? = nil
    
    private let userDetailsView: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.white, for: .normal)
        button.setBackgroundColor(UIColor.fromHex("E5E5E5"), for: .highlighted)
        button.layer.cornerRadius = 6.0
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(editUserTapped), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Poppins-SemiBold", size: 15)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.primaryBlackColor
        label.font = UIFont(name: "Poppins-Medium", size: 12)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()
    
    // MARK: - Actions
    
    func viewDidAppear() {
        configureData()
    }
    
    private func logoutPressed() {
        AppRuntime.showYesNoAlert(title: "Are you sure?", message: "Do you really want to log out?") { action in
            self.viewModel.logout()
            self.changePageHandler?(nil) // show default page
        }
    }
    
    @objc private func editUserTapped() {
        let profileEditVC = ProfileEditViewController()
        AppRuntime.pushToNavigation(profileEditVC)
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = .clear
        
        addSubview(userDetailsView)
        userDetailsView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 128)
        
        addSubview(fullnameLabel)
        fullnameLabel.anchor(top: userDetailsView.topAnchor, left: userDetailsView.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        addSubview(emailLabel)
        emailLabel.anchor(top: fullnameLabel.bottomAnchor, left: userDetailsView.leftAnchor, paddingTop: 10, paddingLeft: 20)
        
        addSubview(stackView)
        stackView.anchor(top: userDetailsView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20)
        
        stackView.addArrangedSubview(ProfileViewButton(title: "My Orders") {
            print("My Orders")
        })
        
        addSeparator()
        
        stackView.addArrangedSubview(ProfileViewButton(title: "My Favorites") {
            AppRuntime.pushToNavigation(FavoriteProductsViewController())
        })
        
        addSeparator()
        
        stackView.addArrangedSubview(ProfileViewButton(title: "Logout", handler: self.logoutPressed))
        
        addSeparator()
        
        self.anchor(bottom: stackView.bottomAnchor)
        
        configureData()
    }
    
    private func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = Constants.primaryGrayColor
        separator.setHeight(height: 1)
        stackView.addArrangedSubview(separator)
    }
    
    public func configureData() {
        fullnameLabel.text = viewModel.displayName
        emailLabel.text = viewModel.emailAddress
    }
}
