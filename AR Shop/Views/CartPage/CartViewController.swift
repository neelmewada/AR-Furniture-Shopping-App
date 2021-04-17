//
//  CartViewController.swift
//  AR Shop
//
//  Created by Neel Mewada on 15/04/21.
//

import UIKit

class CartViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = CartView(CartViewModel())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Properties
    
    
    
    // MARK: - Helpers
    
    private func configureView() {
        
    }
    
    public func configureData() {
        
    }
}
