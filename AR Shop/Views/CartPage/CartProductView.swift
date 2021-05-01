//
//  CartProductView.swift
//  AR Shop
//
//  Created by Neel Mewada on 16/04/21.
//

import UIKit

class CartProductView: UIView {
    // MARK: - Lifecycle
    
    private var viewModel: CartProductViewModel
    
    init(_ viewModel: CartProductViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.configureView()
        self.viewModel.setUpdateCallback(self.viewModelDidChange)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = coder.decodeObject() as! CartProductViewModel
        super.init(coder: coder)
        self.configureView()
        self.viewModel.setUpdateCallback(self.viewModelDidChange)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(viewModel)
    }
    
    /// Use this function to make/push edits & changes to the viewModel
    func viewDidChange() {
        viewModel.productAmount = amountStepperView.value
        viewModel.publishProductAmount()
        
        self.amountChangeCallback?()
    }
    
    /// Called when the viewModel is modified/set `externally`. Use this function to update data displayed by this view.
    func viewModelDidChange() {
        configureData()
    }
    
    // MARK: - Properties
    
    private let thumbnailView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        return view
    }()
    
    private let productTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 13)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 11)
        label.textColor = UIColor.fromHex("353535")
        return label
    }()
    
    private lazy var amountStepperView: CartAmountStepperView = {
        let stepper = CartAmountStepperView(min: 1, max: 3)
        stepper.setValueChangeEventListener(self.viewDidChange)
        return stepper
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var amountChangeCallback: (() -> ())?
    
    // MARK: - Actions
    
    @objc func deleteButtonPressed() {
        viewModel.removeProductFromCart()
        //self.removeFromSuperview()
        self.amountChangeCallback?()
    }
    
    func setAmountChangeCallback(_ callback: @escaping () -> ()) {
        self.amountChangeCallback = callback
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = .white
        layer.cornerRadius = 6
        clipsToBounds = true
        
        addSubview(thumbnailView)
        thumbnailView.setDimensions(height: 64, width: 64)
        thumbnailView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 20)
        
        addSubview(deleteButton)
        deleteButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 14, paddingRight: 14, width: 16, height: 16)
        
        addSubview(productTitle)
        productTitle.anchor(top: topAnchor, left: thumbnailView.rightAnchor, right: rightAnchor, paddingTop: 22, paddingLeft: 10, paddingRight: 20)
        
        addSubview(productPriceLabel)
        productPriceLabel.anchor(left: thumbnailView.rightAnchor, bottom: bottomAnchor, paddingLeft: 10, paddingBottom: 25)
        
        addSubview(amountStepperView)
        amountStepperView.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 16, paddingRight: 16)
        
        configureData()
    }
    
    public func configureData() {
        let url = URL.init(string: viewModel.productThumbnailUrl)
        thumbnailView.sd_setImage(with: url, placeholderImage: UIImage(named: "white_square"), options: .delayPlaceholder, completed: nil)
        
        productTitle.text = viewModel.productTitle
        productPriceLabel.text = viewModel.productPriceText
        amountStepperView.value = viewModel.productAmount
    }
}
