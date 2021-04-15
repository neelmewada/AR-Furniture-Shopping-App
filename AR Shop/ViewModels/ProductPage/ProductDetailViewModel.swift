//
//  ProductDetailViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 13/04/21.
//

import UIKit

class ProductDetailViewModel: ViewModel {
    // MARK: - Lifecycle
    
    public var product: Product
    
    init(_ product: Product) {
        self.product = product
        super.init()
        AppModel.shared.subscribeForChanges(self.modelDidChange)
    }
    
    /// Called when the main model is changed `externally`.
    private func modelDidChange() {
        if let id = product.id {
            product = AppModel.shared.loadedProducts[id] ?? Product()
        }
        updateCallback?()
    }
    
    // MARK: - ViewModel Interface
    
    public var selectedColorIndex: Int = 0
    public var productAmount: Int = 1
    
    var productReviewsText: String {
        return "\(product.reviews) Reviews"
    }
    
    var productRating: Float {
        return product.rating
    }
    
    var productRatingText: String {
        return String(format: "%.1f", product.rating)
    }
    
    var productTitle: String {
        return product.productName
    }
    
    var productDescription: String {
        return product.productDescription
    }
    
    var categoriesText: String {
        var str: String = ""
        for i in 0..<product.categories.count {
            str.append("\(product.categories[i])")
            if i < product.categories.count - 1 {
                str.append(", ")
            }
        }
        return str
    }
    
    var productPriceLabel: String {
        return "$\(String(format: "%.2f", product.productPrice))"
    }
    
    var galleryImageUrl: URL? {
        return URL.init(string: product.thumbnailUrl)
    }
}
