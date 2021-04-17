//
//  RootNavigationController.swift
//  AR Shop
//
//  Created by Neel Mewada on 14/04/21.
//

import UIKit

class RootNavigationController: UINavigationController {
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .darkContent
    }
}
