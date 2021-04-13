//
//  MainTabController.swift
//  AR Shop
//
//  Created by Neel Mewada on 12/04/21.
//

import UIKit

class MainTabController: UITabBarController {
    // MARK: - Properties
    
    var mainTabBar: MainTabBar!
    var tabBarHeight: CGFloat = 82.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Helpers
    
    private func configureViewController() {
        let tabItems: [MainTabItem] = [.home, .products, .search, .profile]
        
        setupCustomTabMenu(tabItems) { controllers in
            self.viewControllers = controllers
        }
        
        self.selectedIndex = 0
    }
    
    func setupCustomTabMenu(_ items: [MainTabItem], completion: @escaping ([UIViewController]) -> Void) {
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        
        tabBar.isHidden = true
        
        self.mainTabBar = MainTabBar(menuItems: items, frame: frame)
        self.mainTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.mainTabBar.clipsToBounds = false
        self.mainTabBar.itemTappedCallback = self.changeTab
        self.mainTabBar.backgroundColor = .clear
        
        self.view.addSubview(mainTabBar)
        
        NSLayoutConstraint.activate([
            self.mainTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            self.mainTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            self.mainTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            self.mainTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight), // Fixed height for nav menu
            self.mainTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])
        
        for i in 0 ..< items.count {
            controllers.append(items[i].viewController) // we fetch the matching view controller and append here
        }
        
        self.view.layoutIfNeeded()
        completion(controllers)
    }
    
    func changeTab(tab: Int) {
        self.selectedIndex = tab
    }
    
    private func templateNavigationController(unselectedImage: String, selectedImage: String, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.isHidden = true
        nav.navigationBar.barStyle = .default
        
        
        
        nav.tabBarItem.image = UIImage(named: unselectedImage)?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        return nav
    }
}
