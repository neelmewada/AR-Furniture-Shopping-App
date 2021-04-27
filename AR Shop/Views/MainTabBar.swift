//
//  MainTabBar.swift
//  AR Shop
//
//  Created by Neel Mewada on 12/04/21.
//

import UIKit

// MARK: - MainTabBar

class MainTabBar: UIView {
    // MARK: - Properties
    
    private var menuItems: [MainTabItem] = []
    private var iconViewTopConstraints: [NSLayoutConstraint] = []
    
    var itemTappedCallback: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(menuItems: [MainTabItem], frame: CGRect) {
        self.init(frame: frame)
        
        self.menuItems = menuItems
        self.layer.backgroundColor = UIColor.white.cgColor
        
        let backgroundView = UIView(frame: frame)
        self.addSubview(backgroundView)
        backgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 20
        backgroundView.backgroundColor = .white
        
        for i in 0 ..< menuItems.count {
            let itemWidth = self.frame.width / CGFloat(menuItems.count)
            let leadingAnchor = itemWidth * CGFloat(i)
            
            let itemView = self.createTabItem(item: menuItems[i])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = false
            itemView.tag = i
            itemView.backgroundColor = .clear
            self.addSubview(itemView)
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalTo: self.heightAnchor),
                itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor),
                itemView.topAnchor.constraint(equalTo: self.topAnchor),
            ])
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.activateTab(tab: 0)
    }
    
    func createTabItem(item: MainTabItem) -> UIView {
        let tabBarItem = UIView(frame: .zero)
        let itemIconView = UIImageView(frame: .zero)
        let ovalBackground = UIImageView(frame: .zero)
        
        itemIconView.image = item.icon!.withRenderingMode(.automatic)
        itemIconView.translatesAutoresizingMaskIntoConstraints = false
        itemIconView.clipsToBounds = false
        itemIconView.contentMode = .scaleAspectFit
        
        ovalBackground.image = UIImage(named: "oval_bg")
        ovalBackground.translatesAutoresizingMaskIntoConstraints = false
        ovalBackground.contentMode = .scaleAspectFit
        ovalBackground.alpha = 0
        ovalBackground.layer.shadowColor = UIColor.black.cgColor
        ovalBackground.layer.shadowOpacity = 0.15
        ovalBackground.layer.shadowRadius = 20
        
        tabBarItem.layer.backgroundColor = UIColor.white.cgColor
        tabBarItem.addSubview(ovalBackground)
        tabBarItem.addSubview(itemIconView)
        tabBarItem.translatesAutoresizingMaskIntoConstraints = false
        tabBarItem.clipsToBounds = false
        
        NSLayoutConstraint.activate([
            itemIconView.heightAnchor.constraint(equalToConstant: 20), // Fixed height for our tab item(25pts)
            itemIconView.widthAnchor.constraint(equalToConstant: 20), // Fixed width for our tab item icon
            itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemIconView.leadingAnchor.constraint(equalTo: tabBarItem.leadingAnchor, constant: 35),
            ovalBackground.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor, constant: 2),
            ovalBackground.widthAnchor.constraint(equalToConstant: 80),
            ovalBackground.heightAnchor.constraint(equalToConstant: 80),
            ovalBackground.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: -20),
        ])
        
        let constraint = itemIconView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 8)
        constraint.isActive = true
        self.iconViewTopConstraints.append(constraint)
        
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        
        return tabBarItem
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.switchTab(from: activeItem, to: sender.view!.tag)
    }
    
    func switchTab(from: Int, to: Int) {
        self.deactivateTab(tab: from)
        self.activateTab(tab: to)
    }
    
    func activateTab(tab: Int) {
        let tabToActivate = self.subviews[1 + tab]
        tabToActivate.subviews[0].alpha = 1.0
        
        let iconImageView = tabToActivate.subviews[1] as! UIImageView
        iconImageView.image = menuItems[tab].selectedIcon
        iconViewTopConstraints[tab].constant = 0
        
        self.itemTappedCallback?(tab)
        
        self.activeItem = tab
    }
    
    func deactivateTab(tab: Int) {
        let inactiveTab = self.subviews[1 + tab]
        inactiveTab.subviews[0].alpha = 0.0
        
        let iconImageView = inactiveTab.subviews[1] as! UIImageView
        iconImageView.image = menuItems[tab].icon
        iconViewTopConstraints[tab].constant = 8
        
    }
}

// MARK: - MainTabItem

enum MainTabItem: String, CaseIterable {
    case home = "home"
    case products = "products"
    case search = "search"
    case profile = "profile"
    
    var viewController: UIViewController {
        switch self {
        case .home:
            return templateNavigationController(rootViewController: HomeViewController())
        case .products:
            let vc = templateNavigationController(rootViewController: UIViewController())
            let field = UITextField(frame: CGRect(x: 10, y: 10, width: 250, height: 50))
            vc.view.addSubview(field)
            field.borderStyle = .roundedRect
            field.anchor(top: vc.view.topAnchor, left: vc.view.leftAnchor, right: vc.view.rightAnchor, paddingTop: 100, paddingLeft: 30, paddingRight: 30, height: 100)
            vc.view.backgroundColor = .white
            return vc
        case .search:
            let vc = templateNavigationController(rootViewController: UIViewController())
            vc.view.backgroundColor = .yellow
            return vc
        case .profile:
            return templateNavigationController(rootViewController: ProfileViewController())
        }
    }
    
    private func templateNavigationController(rootViewController: UIViewController) -> UIViewController {
        return rootViewController
    }
    
    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "home_black")
        case .products:
            return UIImage(named: "product_black")
        case .search:
            return UIImage(named: "product_black")
        case .profile:
            return UIImage(named: "user_black")
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "home_white")
        case .products:
            return UIImage(named: "product_white")
        case .search:
            return UIImage(named: "product_white")
        case .profile:
            return UIImage(named: "user_white")
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized
    }
}
