//
//  RegisterViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 22/04/21.
//

import Foundation
import UIKit

class RegisterViewModel: ViewModel {
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        AppModel.shared.subscribeForChanges(self.modelDidChange)
    }
    
    /// Called when the main model is changed `externally`. Use it to update this viewmodel with new data.
    private func modelDidChange() {
        updateCallback?()
    }
    
    // MARK: - Helpers
    
    private func showAlertView(_ show: Bool, title: String, message: String) {
        if !show {
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        AppRuntime.topViewController?.present(alert, animated: true)
    }
    
    // MARK: - ViewModel Interface
    
    public var emailAddress: String = ""
    public var fullName: String = ""
    public var password: String = ""
    public var confirmPassword: String = ""
    
    func validateForm(showAlert: Bool = false) -> Bool {
        if !emailAddress.isValidEmail {
            showAlertView(showAlert, title: "Invalid Email", message: "Please enter a valid email address.")
            return false
        }
        if !password.isValidPassword {
            showAlertView(showAlert, title: "Weak Password", message: "The password must have at least 6 characters.")//"The password must have at least 8 characters, 1 capital letter, 1 lowercase letter, and 1 digit.")
            return false
        }
        if password != confirmPassword {
            showAlertView(showAlert, title: "Passwords Don't Match", message: "The password and confirm password fields don't match. Please type the same password in both fields.")
            return false
        }
        if fullName.isEmpty {
            showAlertView(showAlert, title: "Full Name required", message: "Please enter your Full Name. It's a required field.")
            return false
        }
        return true
    }
    
    func registerUser(_ completion: @escaping (Error?) -> ()) -> Bool {
        if !validateForm(showAlert: true) {
            return false
        }
        
        AppModel.shared.registerUser(email: emailAddress, fullname: fullName, password: password, completion: completion)
        return true
    }
}
