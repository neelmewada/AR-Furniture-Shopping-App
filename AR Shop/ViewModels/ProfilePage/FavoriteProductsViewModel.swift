//
//  FavoriteProductsViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 29/04/21.
//

import UIKit

class FavoriteProductsViewModel: ViewModel {
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
    
    var favoriteProducts: [Product] {
        return AppModel.shared.favoriteProducts
    }
}
