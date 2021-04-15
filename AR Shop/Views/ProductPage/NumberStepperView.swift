//
//  NumberStepperView.swift
//  AR Shop
//
//  Created by Neel Mewada on 14/04/21.
//

import UIKit

class NumberStepperView: UIView {
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
            valueChangedEvent.raise()
        }
    }
    
    private lazy var _value: Int = {
        return minimumValue
    }()
    
    private let valueChangedEvent: Event = Event()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: 17)
        label.textColor = .black
        label.text = "\(_value)"
        return label
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(incrementButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
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
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 10.0
        
        let arrowImageView = UIImageView()
        addSubview(arrowImageView)
        arrowImageView.image = UIImage(named: "updown_arrows")
        arrowImageView.setDimensions(height: 18, width: 11)
        arrowImageView.anchor(right: self.rightAnchor, paddingRight: 14)
        arrowImageView.centerY(inView: self)
        
        addSubview(numberLabel)
        numberLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, width: 30)
        
        addSubview(incrementButton)
        incrementButton.anchor(top: topAnchor, right: rightAnchor, width: 34, height: 27)
        
        addSubview(decrementButton)
        decrementButton.anchor(bottom: bottomAnchor, right: rightAnchor, width: 34, height: 27)
    }
    
    public func addValueChangeEventListener(_ handler: @escaping Event.EventHandler) {
        valueChangedEvent.addHandler(handler)
    }
}
