//
//  TrendingViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 13/04/21.
//

import UIKit

class TrendingViewModel: ViewModel {
    // MARK: - Lifecycle
    
    public var trendingProducts: [Product] = []
    
    override init() {
        super.init()
        AppModel.shared.subscribeForChanges(self.modelDidChange)
    }
    
    /// called when the main model is changed `externally`
    private func modelDidChange() {
        self.trendingProducts = AppModel.shared.trendingProducts
        updateCallback?()
    }
    
    // MARK: - ViewModel Interface
    
}
