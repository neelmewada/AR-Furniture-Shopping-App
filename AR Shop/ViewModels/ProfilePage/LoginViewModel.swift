//
//  LoginViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 23/04/21.
//

import UIKit

class LoginViewModel: ViewModel {
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
    public var password: String = ""
    
    func validateForm(showAlert: Bool = false) -> Bool {
        if !emailAddress.isValidEmail {
            showAlertView(showAlert, title: "Invalid Email", message: "Please enter a valid email address.")
            return false
        }
        return true
    }
    
    func loginUser(_ completion: @escaping (Error?) -> ()) -> Bool {
        if !validateForm(showAlert: true) {
            return false
        }
        
        AppModel.shared.loginUser(email: emailAddress, password: password, completion: completion)
        return true
    }
}


