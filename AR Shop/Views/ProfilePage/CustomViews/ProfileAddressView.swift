//
//  ProfileAddressView.swift
//  AR Shop
//
//  Created by Neel Mewada on 27/04/21.
//

import UIKit

class ProfileAddressView: UIView {
    // MARK: - Lifecycle
    
    init(_ address: Address? = nil, _ editHandler: (() -> ())? = nil) {
        self.editButtonHandler = editHandler
        self.address = address
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    // MARK: - Properties
    
    private var editButtonHandler: (() -> ())? = nil
    private var address: Address? = nil
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 12)
        label.textColor = Constants.primaryBlackColor
        label.numberOfLines = 3
        return label
    }()
    
    private let bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = Constants.primaryGrayColor
        return bottomLine
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle(nil, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "edit-button")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    
    @objc private func editButtonPressed() {
        editButtonHandler?()
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = .clear
        
        addSubview(addressLabel)
        addressLabel.anchor(left: leftAnchor, width: 240)
        addressLabel.centerY(inView: self)
        
        addSubview(editButton)
        editButton.anchor(right: rightAnchor)
        editButton.centerY(inView: self)
        
        addSubview(bottomLine)
        bottomLine.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editButtonPressed)))
        
        configureData()
    }
    
    func configureData() {
        if address == nil {
            addressLabel.text = ""
            return
        }
        addressLabel.text = "\(address!.address)\n \(address!.city), \(address!.state) \(address!.zip)"
    }
    
    func setAddress(address: Address) {
        self.address = address
        configureData()
    }
}
