//
//  ProfileEditViewController.swift
//  AR Shop
//
//  Created by Neel Mewada on 25/04/21.
//

import UIKit

class ProfileEditViewController: UIViewController {
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func loadView() {
        self.view = ProfileEditView()
    }
    
    // MARK: - Properties
    
    
    // MARK: - Helpers
    
    private func configureViewController() {
        
    }
}
