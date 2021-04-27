//
//  ProductDetailViewController.swift
//  AR Shop
//
//  Created by Neel Mewada on 24/04/21.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    init(_ product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.product = Product()
        super.init(coder: coder)
    }
    
    private var product: Product
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func loadView() {
        self.view = ProductDetailView(product)
    }
}
