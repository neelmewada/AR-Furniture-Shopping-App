//
//  ProductCollectionView.swift
//  AR Shop
//
//  Created by Neel Mewada on 29/04/21.
//

import UIKit

class ProductCollectionView: UICollectionView {
    // MARK: - Lifecycle
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 30
        super.init(frame: .zero, collectionViewLayout: layout)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    /// Use this function to make push edits & changes from this view to the viewModel
    func viewDidChange() {
        
    }
    
    // MARK: - Properties
    
    private static let reuseId = "cell"
    
    private var products: [Product] = []
    
    // MARK: - Actions
    
    private func productTapped(_ product: Product?) {
        guard let product = product else { return }
        
        AppRuntime.pushToNavigation(ProductDetailViewController(product))
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        backgroundColor = .clear
        
        self.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: Self.reuseId)
        
        self.dataSource = self
        self.delegate = self
        
        configureData()
    }
    
    func configureData() {
        
    }
    
    func setProducts(_ products: [Product]) {
        self.products = products
        reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ProductCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseId, for: indexPath) as! ProductCollectionViewCell
        cell.configureCell(products[indexPath.item])
        cell.setTapCallback(productTapped(_:))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 200)
    }
}
