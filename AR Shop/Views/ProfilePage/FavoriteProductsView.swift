//
//  FavoriteProductsView.swift
//  AR Shop
//
//  Created by Neel Mewada on 29/04/21.
//

import UIKit

class FavoriteProductsView: UIView {
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        configureView()
        viewModel.setUpdateCallback(self.viewModelDidChange)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        viewModel.setUpdateCallback(self.viewModelDidChange)
    }
    
    /// Use this function to make/push edits & changes to the viewModel
    func viewDidChange() {
        
    }
    
    /// Called when the viewModel is modified/set `externally`. Use this function to update data displayed by this view.
    func viewModelDidChange() {
        configureData()
    }
    
    // MARK: - Properties
    
    private let viewModel = FavoriteProductsViewModel()
    
    private let topBar = GenericTopBar("My Favorites")
    
    private let productCollectionView = ProductCollectionView()
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = Constants.primaryBackgroundColor
        
        addSubview(topBar)
        topBar.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingBottom: -50)
        
        addSubview(productCollectionView)
        productCollectionView.anchor(top: topBar.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 35, paddingLeft: 30, paddingRight: 30)
        
        configureData()
    }
    
    func configureData() {
        productCollectionView.setProducts(viewModel.favoriteProducts)
    }
}
