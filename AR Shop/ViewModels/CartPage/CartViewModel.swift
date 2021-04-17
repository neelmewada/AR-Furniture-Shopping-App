//
//  CartViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 15/04/21.
//

import UIKit

class CartViewModel: ViewModel {
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        AppModel.shared.subscribeForChanges(self.modelDidChange)
    }
    
    /// Called when the main model is changed `externally`. Use it to update this viewmodel with new data.
    private func modelDidChange() {
        updateCallback?()
    }
    
    // MARK: - ViewModel Interface
    
    public var productsInCart: [CartProductInfo] {
        get {
            AppModel.shared.productsInCart.map { $0.value }
        }
    }
}
