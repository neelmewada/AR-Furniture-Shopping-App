//
//  CartAmountStepperView.swift
//  AR Shop
//
//  Created by Neel Mewada on 16/04/21.
//

import UIKit

class CartAmountStepperView: UIView {
    // MARK: - Lifecycle
    
    init(min: Int, max: Int) {
        self.minimumValue = min
        self.maximumValue = max
        super.init(frame: .zero)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    // MARK: - Properties
    
    public var minimumValue: Int = 0
    public var maximumValue: Int = 0
    
    public var value: Int {
        get {
            return _value
        }
        set {
            _value = newValue
            numberLabel.text = "\(_value)"
            valueChangedEvent?()
        }
    }
    
    private lazy var _value: Int = {
        return minimumValue
    }()
    
    private var valueChangedEvent: (() -> ())?
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: 11)
        label.textColor = .black
        label.text = "\(_value)"
        return label
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(incrementButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(decrementButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    
    @objc func incrementButtonPressed() {
        if value < maximumValue {
            value += 1
        }
    }
    
    @objc func decrementButtonPressed() {
        if value > minimumValue {
            value -= 1
        }
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        
        setDimensions(height: 28, width: 70)
        
        addSubview(numberLabel)
        numberLabel.center(inView: self)
        
        addSubview(decrementButton)
        decrementButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, width: 25)
        
        addSubview(incrementButton)
        incrementButton.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, width: 25)
    }
    
    public func setValueChangeEventListener(_ handler: @escaping () -> ()) {
        valueChangedEvent = handler
    }
}
