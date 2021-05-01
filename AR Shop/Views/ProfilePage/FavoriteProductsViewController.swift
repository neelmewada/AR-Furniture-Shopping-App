//
//  FavoriteProductsViewController.swift
//  AR Shop
//
//  Created by Neel Mewada on 29/04/21.
//

import UIKit

class FavoriteProductsViewController: UIViewController {
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func loadView() {
        self.view = FavoriteProductsView()
    }
    
    // MARK: - Properties
    
    
    // MARK: - Helpers
    
    private func configureViewController() {
        
    }
}
