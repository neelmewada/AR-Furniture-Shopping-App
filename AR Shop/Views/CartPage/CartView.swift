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
        
        configureData()
    }
    
    public func configureData() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            //view.removeFromSuperview()
        }
        
        let productsInCart = viewModel.productsInCart
        if productsInCart.count == 0 {
            return
        }
        
        for prod in productsInCart {
            let productView = CartProductView(CartProductViewModel(prod))
            stackView.addArrangedSubview(productView)
            productView.setHeight(height: 100)
        }
    }
    
    // MARK: - Properties
    
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
}
