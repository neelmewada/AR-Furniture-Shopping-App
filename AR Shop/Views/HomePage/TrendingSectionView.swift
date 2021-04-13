//
//  NewArrivalsSectionView.swift
//  AR Shop
//
//  Created by Neel Mewada on 10/04/21.
//

import UIKit

class TrendingSectionView: UIView {
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Use this function to make push edits & changes from this view to the viewModel
    func viewDidChange() {
        
    }
    
    /// Called when the viewModel is modified/set `externally`. Use this function to update data displayed by this view
    func viewModelDidChange() {
        configureData()
    }
    
    // MARK: - Properties
    
    private let trendingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trendings"
        label.font = UIFont(name: "Poppins-SemiBold", size: 20)
        label.textColor = .black
        return label
    }()
    
    private let productStackView = UIStackView()
    
    private var productThumnailViews: [ProductThumnbailColumnView] = []
    
    // MARK: - Actions
    
    private func onProductPressed(index: Int) {
        
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        addSubview(trendingTitleLabel)
        trendingTitleLabel.anchor(top: topAnchor, left: leftAnchor)
        
        productStackView.axis = .vertical
        productStackView.spacing = 20
        
        addSubview(productStackView)
        productStackView.anchor(top: trendingTitleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 22)
        
        configureData()
    }
    
    public func configureData() {
        for i in 0..<productStackView.arrangedSubviews.count {
            let view = productStackView.arrangedSubviews[i]
            (view as! ProductThumnbailColumnView).viewModel.product = ProductModel.shared.products[i]
        }
        
        if productStackView.arrangedSubviews.count > 0 {
            return
        }
        
        for i in 0..<min(ProductModel.shared.products.count, 3) {
            let product = ProductModel.shared.products[i]
            let productView = ProductThumnbailColumnView(ProductThumnbailColumnViewModel(product: product), indexInParent: i, tapCallback: onProductPressed)
            productStackView.addArrangedSubview(productView)
            productView.setHeight(height: 100)
        }
    }
}
