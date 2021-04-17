//
//  CartProductViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 16/04/21.
//

import UIKit

class CartProductViewModel: ViewModel {
    // MARK: - Lifecycle
    
    init(_ productInfo: CartProductInfo) {
        self.productCartInfo = productInfo
        super.init()
        AppModel.shared.subscribeForChanges(self.modelDidChange)
    }
    
    /// Called when the main model is changed `externally`. Use it to update this viewmodel with new data.
    private func modelDidChange() {
        updateCallback?()
    }
    
    // MARK: - Properties
    
    private var productCartInfo: CartProductInfo
    
    // MARK: - ViewModel Interface
    
    public var productTitle: String {
        return productCartInfo.productReference.productName
    }
    
    public var productThumbnailUrl: String {
        return productCartInfo.productReference.thumbnailUrl
    }
    
    public var productPriceText: String {
        return "$\(String(format: "%.2f", productCartInfo.productReference.productPrice))"
    }
    
    public var productAmount: Int {
        get { return productCartInfo.amount }
        set {
            productCartInfo.amount = newValue
        }
    }
    
    public func publishProductAmount() {
        AppModel.shared.setAmountForProductInCart(productCartInfo.productReference, amount: productAmount, fireEvent: false) // disable fireEvent to avoid infinite event loop
    }
    
    public func removeProductFromCart() {
        AppModel.shared.removeProductFromCart(productCartInfo.productReference, fireEvent: false)
    }
}
