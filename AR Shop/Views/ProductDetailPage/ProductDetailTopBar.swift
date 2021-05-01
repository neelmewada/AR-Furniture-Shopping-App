//
//  ProductDetailTopBar.swift
//  AR Shop
//
//  Created by Neel Mewada on 15/04/21.
//

import UIKit

class ProductDetailTopBar: UIView, UIScrollViewDelegate {
    
    // MARK: - Lifecycle
    
    init(scrollView: UIScrollView, _ favoriteHandler: ((Bool) -> ())? = nil) {
        self.favoriteHandler = favoriteHandler
        self.scrollView = scrollView
        super.init(frame: .zero)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    // MARK: - Properties
    
    private var scrollView: UIScrollView? = nil
    
    private var favoriteHandler: ((Bool) -> ())? = nil
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .clear
        let image = UIImage(named: "left-arrow-white")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .clear
        button.isSelected = true
        button.imageView?.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        button.imageView?.tintColor = Constants.primaryRedColor
        button.setImage(image, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    public var isFavorite: Bool {
        get { favoriteButton.isSelected }
        set { favoriteButton.isSelected = newValue }
    }
    
    // MARK: - Actions
    
    @objc private func backButtonPressed() {
        AppRuntime.navigationController?.popViewController(animated: true)
    }
    
    @objc private func favoriteButtonPressed() {
        isFavorite = !isFavorite
        favoriteHandler?(isFavorite)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let posY = scrollView.contentOffset.y
        let t = Math.clamp01((posY - 15) / 10)
        
        backgroundColor = UIColor(white: 1, alpha: Math.lerpUnclamped(0, 1, t))
        backButton.imageView?.tintColor = UIColor(white: Math.lerpUnclamped(1, 0, t), alpha: 1)
        
        
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = .clear
        
        addSubview(backButton)
        backButton.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 18, paddingBottom: 10, width: 24, height: 30) // icon: 12w, 20h
        
        addSubview(favoriteButton)
        favoriteButton.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10, paddingRight: 18, width: 30, height: 30)
        
        scrollView?.delegate = self
    }
    
    func setFavoriteButton(hidden: Bool) {
        favoriteButton.isHidden = hidden
    }
}
