//
//  RootView.swift
//  AR Shop
//
//  Created by Neel Mewada on 10/04/21.
//

import UIKit


class HomeView: UIView {
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover"
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 22)
        label.font = label.font.withSize(28)
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cart"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(cartButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        return view
    }()
    
    private let heroSectionView = HeroSectionView(viewModel: HeroSectionViewModel())
    
    private let trendingView = TrendingSectionView()
    
    private let scrollContentView = UIView()
    
    // MARK: - Actions
    
    @objc func cartButtonPressed() {
        let cartViewController = CartViewController()
        SceneDelegate.navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = Constants.primaryBackgroundColor
        
        addSubview(scrollView)
        scrollView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let ht = scrollContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ht.isActive = true
        ht.priority = UILayoutPriority(250)
        
        scrollContentView.addSubview(titleLabel)
        titleLabel.anchor(top: scrollContentView.topAnchor, left: scrollContentView.leftAnchor, paddingTop: 10, paddingLeft: 30)
        
        scrollContentView.addSubview(cartButton)
        cartButton.anchor(top: scrollView.topAnchor, right: scrollContentView.rightAnchor, paddingTop: 10, paddingRight: 30)
        cartButton.setDimensions(height: 22, width: 22)
        
        scrollContentView.addSubview(heroSectionView)
        heroSectionView.anchor(top: titleLabel.bottomAnchor, left: scrollContentView.leftAnchor, right: scrollContentView.rightAnchor, paddingTop: 33, paddingLeft: 30, paddingRight: 30, height: 200)
        
        scrollContentView.addSubview(trendingView)
        trendingView.anchor(top: heroSectionView.bottomAnchor, left: scrollContentView.leftAnchor, bottom: scrollContentView.bottomAnchor, right: scrollContentView.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingBottom: 82, paddingRight: 30)
    }
}

