//
//  CartView.swift
//  AR Shop
//
//  Created by Neel Mewada on 15/04/21.
//

import UIKit

class CartView: UIView {
    // MARK: - Lifecycle
    
    private var viewModel: CartViewModel
    
    init(_ viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.configureView()
        self.viewModel.setUpdateCallback(self.viewModelDidChange)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = coder.decodeObject() as! CartViewModel
        super.init(coder: coder)
        self.configureView()
        self.viewModel.setUpdateCallback(self.viewModelDidChange)
    }
    
    override func encode(with coder: NSCoder) {
        coder.encode(viewModel)
    }
    
    /// Use this function to make/push edits & changes to the viewModel
    func viewDidChange() {
        
    }
    
    /// Called when the viewModel is modified/set `externally`. Use this function to update data displayed by this view.
    func viewModelDidChange() {
        configureData()
    }
    
    // MARK: - Actions
    
    private func onContinueButtonPressed() {
        
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = UIColor.fromHex("F2F6F9")
        
        addSubview(scrollView)
        scrollView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor)
        
        scrollView.addSubview(contentView)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.isActive = true
        heightConstraint.priority = UILayoutPriority(250)
        
        contentView.addSubview(stackView)
        stackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 80, paddingLeft: 30, paddingRight: 30)
        
        addSubview(topBar)
        topBar.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingBottom: -50)
        
        addSubview(overlayView)
        overlayView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 300)
        
        overlayView.addSubview(subtotalTitleLabel)
        subtotalTitleLabel.anchor(top: overlayView.topAnchor, left: overlayView.leftAnchor, paddingTop: 35, paddingLeft: 30)
        
        overlayView.addSubview(subtotalValueLabel)
        subtotalValueLabel.anchor(top: overlayView.topAnchor, right: overlayView.rightAnchor, paddingTop: 35, paddingRight: 30)
        
        overlayView.addSubview(shippingFeeTitleLabel)
        shippingFeeTitleLabel.anchor(top: subtotalTitleLabel.topAnchor, left: overlayView.leftAnchor, paddingTop: 40, paddingLeft: 30)
        
        overlayView.addSubview(shippingFeeValueLabel)
        shippingFeeValueLabel.anchor(top: subtotalValueLabel.topAnchor, right: overlayView.rightAnchor, paddingTop: 40, paddingRight: 30)
        
        let _ = addSeparator(topAnchor: shippingFeeTitleLabel.bottomAnchor, paddingTop: 40)
        
        overlayView.addSubview(totalTitleLabel)
        totalTitleLabel.anchor(top: shippingFeeTitleLabel.topAnchor, left: overlayView.leftAnchor, paddingTop: 80, paddingLeft: 30)
        
        overlayView.addSubview(totalValueLabel)
        totalValueLabel.anchor(top: shippingFeeValueLabel.topAnchor, right: overlayView.rightAnchor, paddingTop: 80, paddingRight: 30)
        
        overlayView.addSubview(checkoutButton)
        checkoutButton.anchor(left: overlayView.leftAnchor, bottom: overlayView.safeAreaLayoutGuide.bottomAnchor, right: overlayView.rightAnchor, paddingLeft: 30, paddingBottom: 20, paddingRight: 30, height: 54)
        
        configureData()
    }
    
    public func configureData() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        let productsInCart = viewModel.productsInCart
        
        var subtotalAmount: Float = 0
        var shippingFee: Float = 0
        
        for prod in productsInCart {
            let productView = CartProductView(CartProductViewModel(prod))
            subtotalAmount += Float(prod.amount) * (viewModel.getProduct(withID: prod.id)?.productPrice ?? 0.0)
            productView.setAmountChangeCallback(self.viewModelDidChange)
            stackView.addArrangedSubview(productView)
            productView.setHeight(height: 100)
        }
        
        self.subtotalValueLabel.text = "$\(String(format: "%.2f", subtotalAmount))"
        self.shippingFeeValueLabel.text = "$\(String(format: "%.2f", shippingFee))"
        self.totalValueLabel.text = "$\(String(format: "%.2f", (subtotalAmount + shippingFee)))"
        checkoutButton.isEnabled = productsInCart.count > 0
    }
    
    private func addSeparator(topAnchor: NSLayoutYAxisAnchor, paddingTop: CGFloat = 24) -> UIView {
        let separator = UIView()
        overlayView.addSubview(separator)
        separator.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: paddingTop, paddingLeft: 30, paddingRight: 30, height: 1)
        separator.backgroundColor = UIColor.fromHex("C6C5C5")
        return separator
    }
    
    // MARK: - Properties
    
    private lazy var topBar = GenericTopBar("Cart", scrollView: self.scrollView)
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private let contentView = UIView()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let subtotalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.text = "Sub Total"
        label.textColor = .black
        return label
    }()
    
    private let subtotalValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 13)
        label.text = "$0.00"
        label.textColor = .black
        return label
    }()
    
    private let shippingFeeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.text = "Shipping Fee"
        label.textColor = .black
        return label
    }()
    
    private let shippingFeeValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 13)
        label.text = "$0.00"
        label.textColor = .black
        return label
    }()
    
    private let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: 15)
        label.text = "Total"
        label.textColor = .black
        return label
    }()
    
    private let totalValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: 15)
        label.text = "$0.00"
        label.textColor = .black
        return label
    }()
    
    private lazy var checkoutButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Checkout", for: .normal)
        button.setPressedHandler(self.onContinueButtonPressed)
        return button
    }()
}
