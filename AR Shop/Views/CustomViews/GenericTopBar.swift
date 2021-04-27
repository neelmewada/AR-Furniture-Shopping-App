//
//  GenericTopBar.swift
//  AR Shop
//
//  Created by Neel Mewada on 17/04/21.
//

import UIKit

class GenericTopBar: UIView, UIScrollViewDelegate {
    // MARK: - Lifecycle
    
    init(_ title: String, scrollView: UIScrollView? = nil) {
        self.scrollView = scrollView
        self.titleText = title
        super.init(frame: .zero)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        self.titleText = (coder.decodeObject() as? String) ?? ""
        super.init(coder: coder)
        self.configureView()
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(titleText)
    }
    
    // MARK: - Properties
    
    private var scrollView: UIScrollView? = nil
    private let titleText: String
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        let image = UIImage(named: "left-arrow-white")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .black
        button.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: 22)
        label.textColor = .black
        label.text = self.titleText
        return label
    }()
    
    // MARK: - Actions
    
    @objc func backButtonPressed() {
        AppRuntime.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = .clear
        
        addSubview(backButton)
        backButton.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 18, paddingBottom: 10, width: 24, height: 30) // icon: 12w, 20h
        
        addSubview(titleLabel)
        titleLabel.anchor(bottom: bottomAnchor, paddingBottom: 10)
        titleLabel.centerX(inView: self)
        
        scrollView?.delegate = self
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let posY = scrollView.contentOffset.y
        let t = Math.clamp01((posY - 15) / 10)
        
        backgroundColor = UIColor(white: 1, alpha: Math.lerpUnclamped(0, 1, t))
    }
}
