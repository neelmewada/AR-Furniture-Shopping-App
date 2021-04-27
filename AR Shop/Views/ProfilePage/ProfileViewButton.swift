//
//  ProfileViewButton.swift
//  AR Shop
//
//  Created by Neel Mewada on 24/04/21.
//

import UIKit

class ProfileViewButton: UIButton {
    // MARK: - Lifecycle
    
    init(title: String, handler: (() -> ())?) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        self.handler = handler
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    // MARK: - Properties
    
    private var handler: (() -> ())? = nil
    
    // MARK: - Actions
    
    @objc func buttonPressed() {
        handler?()
    }
    
    private let rightArrowIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "right-arrow")?.withRenderingMode(.alwaysOriginal)
        return view
    }()
    
    // MARK: - Helpers
    
    private func configureView() {
        setHeight(height: 60)
        titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 13)
        contentHorizontalAlignment = .left
        contentVerticalAlignment = .center
        
        addSubview(rightArrowIcon)
        rightArrowIcon.anchor(right: rightAnchor)
        rightArrowIcon.centerY(inView: self)
        rightArrowIcon.setDimensions(height: 14, width: 14)
        
        self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    public func setPressedHandler(_ handler: @escaping () -> ()) {
        self.handler = handler
    }
}
