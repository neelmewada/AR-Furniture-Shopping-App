//
//  ProductThumnbailColumnViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 11/04/21.
//

import UIKit

class ProductThumnbailColumnViewModel: ViewModel {
    // MARK: - Lifecycle
    
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
    
    var thumbnailUrl: String? {
        return product?.thumbnailUrl
    }
    
    var productThumbnail: UIImage? {
        return product?.thumbnailImage
    }
    
    var productName: String? {
        return product?.productName
    }
    
    var productPrice: String? {
        guard let product = product else { return "" }
        return "$" + String(format: "%.2f", product.productPrice)
    }
}
