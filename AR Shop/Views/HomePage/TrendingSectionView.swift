//
//  NewArrivalsSectionView.swift
//  AR Shop
//
//  Created by Neel Mewada on 10/04/21.
//

import UIKit

class TrendingSectionView: UIView {
    // MARK: - Lifecycle
    
    private var viewModel: TrendingViewModel
    
    init() {
        self.viewModel = TrendingViewModel()
        super.init(frame: .zero)
        self.viewModel.setUpdateCallback(self.viewModelDidChange)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = TrendingViewModel()
        super.init(coder: coder)
        self.viewModel.setUpdateCallback(self.viewModelDidChange)
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
        print("Product selected: \(index)")
        let productDetailVC = ProductDetailViewController(viewModel.trendingProducts[index])
        //productDetailVC.view = ProductDetailView(viewModel.trendingProducts[index])
        
        SceneDelegate.navigationController?.pushViewController(productDetailVC, animated: true)
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
            (view as! ProductThumnbailColumnView).viewModel.product = viewModel.trendingProducts[i]
        }
        
        if productStackView.arrangedSubviews.count > 0 {
            return
        }
        
        let trendingProducts = viewModel.trendingProducts
        if trendingProducts.count == 0 {
            return
        }
        
        for i in 0..<min(trendingProducts.count, 3) {
            let product = trendingProducts[i]
            let viewModel = ProductThumnbailColumnViewModel(product: product)
            let productView = ProductThumnbailColumnView(viewModel, indexInParent: i, tapCallback: onProductPressed)
            productStackView.addArrangedSubview(productView)
            productView.setHeight(height: 100)
        }
    }
}
