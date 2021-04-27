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
        backgroundColor = .black
        titleLabel?.font = UIFont(name: "Poppins-Bold", size: 17)
        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor(white: 1, alpha: 0.65), for: .highlighted)
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    public func setPressedHandler(_ handler: @escaping () -> ()) {
        self.handler = handler
    }
}
