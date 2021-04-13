//
//  ProductThumnbailColumnViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 11/04/21.
//

import UIKit

class ProductThumnbailColumnViewModel: ViewModel {
    public var product: Product? {
        didSet { updateCallback?() }
    }
    
    override init() {
        
    }
    
    convenience init(product: Product) {
        self.init()
        self.product = product
    }
    
    // MARK: - ViewModel Interface
    
    var productThumbnail: UIImage? {
        return product?.image
    }
    
    var productName: String? {
        return product?.productName
    }
    
    var productPrice: String? {
        return "$" + String(format: "%.2f", product?.price ?? 0.00)
    }
}
