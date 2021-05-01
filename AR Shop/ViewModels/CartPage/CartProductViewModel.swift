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
        guard let productRef = AppModel.shared.getProductWithId(productCartInfo.id) else { return "" }
        return productRef.productName
    }
    
    public var productThumbnailUrl: String {
        guard let productRef = AppModel.shared.getProductWithId(productCartInfo.id) else { return "" }
        return productRef.thumbnailUrl
    }
    
    public var productPriceText: String {
        guard let productRef = AppModel.shared.getProductWithId(productCartInfo.id) else { return "$0.00" }
        return "$\(String(format: "%.2f", productRef.productPrice))"
    }
    
    public var productAmount: Int {
        get { return productCartInfo.amount }
        set {
            productCartInfo.amount = newValue
        }
    }
    
    public func publishProductAmount() {
        guard let productRef = AppModel.shared.getProductWithId(productCartInfo.id) else { return }
        AppModel.shared.setAmountForProductInCart(productRef, amount: productAmount, fireEvent: false) // disable fireEvent to avoid infinite event loop
    }
    
    public func removeProductFromCart() {
        guard let productRef = AppModel.shared.getProductWithId(productCartInfo.id) else { return }
        AppModel.shared.removeProductFromCart(productRef, fireEvent: false) // disable fireEvent to avoid infinite event loop
    }
}
