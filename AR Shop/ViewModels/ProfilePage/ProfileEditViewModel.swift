//
//  ProfileEditViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 25/04/21.
//

import UIKit
import Firebase

class ProfileEditViewModel: ViewModel {
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        AppModel.shared.subscribeForChanges(self.modelDidChange)
        self.loadValues()
    }
    
    /// Called when the main model is changed `externally`. Use it to update this viewmodel with new data.
    private func modelDidChange() {
        loadValues()
    }
    
    // MARK: - Properties
    
    public var currentUser: User? {
        return AppModel.shared.currentUser
    }
    
    public var userData: UserData? {
        return AppModel.shared.userData
    }
    
    // MARK: - Helpers
    
    private func loadValues() {
        fullName = AppModel.shared.currentUser?.displayName
        gender = AppModel.shared.userData?.genderValue ?? .unspecified
        phone = AppModel.shared.userData?.phone
        addresses = AppModel.shared.userData?.addresses ?? []
        updateCallback?()
    }
    
    // MARK: - ViewModel Interface
    
    public var fullName: String?
    public var gender: Gender = .unspecified
    public var phone: String?
    public var addresses: [Address] = []
    
    func pushChanges() {
        guard let currentUser = currentUser else { return }
        
        let changeRequest = currentUser.createProfileChangeRequest()
        changeRequest.displayName = fullName
        changeRequest.commitChanges(completion: nil)
        
        AppModel.shared.userData?.phone = phone ?? ""
        AppModel.shared.userData?.gender = gender.rawValue
        AppModel.shared.userData?.addresses = addresses
        
        AppModel.shared.pushUserData()
    }
}

