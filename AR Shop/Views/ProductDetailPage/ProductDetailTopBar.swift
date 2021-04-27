//
//  ProductDetailTopBar.swift
//  AR Shop
//
//  Created by Neel Mewada on 15/04/21.
//

import UIKit

class ProductDetailTopBar: UIView, UIScrollViewDelegate {
    
    // MARK: - Lifecycle
    
    init(scrollView: UIScrollView) {
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
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        let image = UIImage(named: "left-arrow-white")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    
    @objc func backButtonPressed() {
        AppRuntime.navigationController?.popViewController(animated: true)
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
        
        scrollView?.delegate = self
    }
    
}
