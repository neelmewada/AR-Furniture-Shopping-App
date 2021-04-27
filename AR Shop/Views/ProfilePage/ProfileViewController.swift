//
//  ProfileViewController.swift
//  AR Shop
//
//  Created by Neel Mewada on 22/04/21.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showDefaultPage()
        currentProfileView?.viewDidAppear()
    }
    
    public func reloadView() {
        showDefaultPage()
    }
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 22)
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var currentProfileView: ProfileViewProtocol? = nil
    
    private var currentProfilePage = ProfilePage.registerPage
    
    // MARK: - Actions
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
    
    public func changePage(to newPage: ProfilePage?) {
        guard let newPage = newPage else {
            showDefaultPage()
            return
        }
        
        if currentProfilePage == newPage {
            return
        }
        
        switch newPage {
        case .loginPage:
            showLoginPage()
        case .registerPage:
            showRegisterPage()
        case .userPage:
            showUserPage()
        }
    }
    
    // MARK: - Helpers
    
    private func configureViewController() {
        view.backgroundColor = Constants.primaryBackgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        titleLabel.centerX(inView: view)
        
        view.addSubview(containerView)
        containerView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingBottom: 80, paddingRight: 30)
        
        showDefaultPage()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    private func showDefaultPage() {
        if AppModel.shared.isUserSignedIn {
            showUserPage()
        } else {
            showLoginPage()
        }
    }
    
    private func showLoginPage() {
        currentProfilePage = .loginPage
        currentProfileView?.removeFromSuperview()
        currentProfileView = LoginView(pageHandler: self.changePage)
        containerView.addSubview(currentProfileView!)
        currentProfileView!.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor)
    }
    
    private func showRegisterPage() {
        currentProfilePage = .registerPage
        currentProfileView?.removeFromSuperview()
        currentProfileView = RegisterView(pageHandler: self.changePage)
        containerView.addSubview(currentProfileView!)
        currentProfileView!.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor)
    }
    
    private func showUserPage() {
        currentProfilePage = .userPage
        currentProfileView?.removeFromSuperview()
        currentProfileView = ProfileView(pageHandler: self.changePage)
        containerView.addSubview(currentProfileView!)
        currentProfileView!.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor)
    }
}

// MARK: - Extras

enum ProfilePage {
    case registerPage
    case loginPage
    case userPage
    
    func createView(pageHandler: @escaping ProfilePageHandler) -> ProfileViewProtocol {
        switch self {
        case .loginPage:
            return LoginView(pageHandler: pageHandler)
        case .registerPage:
            return RegisterView(pageHandler: pageHandler)
        case .userPage:
            return ProfileView(pageHandler: pageHandler)
        }
    }
}

typealias ProfilePageHandler = (ProfilePage?) -> ()

enum AuthError: Error {
    case invalidFormInput
    
}
