//
//  HomeViewController.swift
//  AR Shop
//
//  Created by Neel Mewada on 10/04/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem.image = UIImage(named: "home")?.withTintColor(.black)
        tabBarItem.title = "Home"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Properties
    
}
