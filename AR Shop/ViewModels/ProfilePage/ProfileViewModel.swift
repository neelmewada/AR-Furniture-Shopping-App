//
//  ProfileViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 24/04/21.
//

import Foundation
import UIKit
import Firebase

class ProfileViewModel: ViewModel {
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        AppModel.shared.subscribeForChanges(self.modelDidChange)
    }
    
    /// Called when the main model is changed `externally`. Use it to update this viewmodel with new data.
    private func modelDidChange() {
        updateCallback?()
    }
    
    // MARK: - Properties
    
    public var currentUser: User? {
        return AppModel.shared.currentUser
    }
    
    // MARK: - ViewModel Interface
    
    public var emailAddress: String? {
        return currentUser?.email
    }
    
    public var displayName: String? {
        return currentUser?.displayName
    }
    
    func logout() {
        AppModel.shared.logoutUser()
    }
}
