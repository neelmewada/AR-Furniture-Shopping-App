//
//  CustomButton.swift
//  AR Shop
//
//  Created by Neel Mewada on 14/04/21.
//

import UIKit

class CustomButton: UIButton {
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
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
    
    // MARK: - Helpers
    
    private func configureView() {
        isMultipleTouchEnabled = false
        layer.cornerRadius = 10
        clipsToBounds = true
        setBackgroundColor(.black, for: .normal)
        setBackgroundColor(UIColor.black.withAlphaComponent(0.8), for: .highlighted)
        setBackgroundColor(UIColor.black.withAlphaComponent(0.5), for: .disabled)
        titleLabel?.font = UIFont(name: "Poppins-Bold", size: 17)
        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    public func setPressedHandler(_ handler: @escaping () -> ()) {
        self.handler = handler
    }
}
