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
            product = AppModel.shared.loadedProducts[id]!
        }
        updateCallback?()
    }
    
    // MARK: - ViewModel Interface
    
    var galleryImageUrl: URL? {
        return URL.init(string: product.thumbnailUrl)
    }
}
