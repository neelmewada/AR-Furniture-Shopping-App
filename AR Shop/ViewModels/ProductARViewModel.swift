//
//  ProductARViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 30/04/21.
//

import UIKit

class ProductARViewModel: ViewModel {
    // MARK: - Lifecycle
    
    init(_ productId: String?) {
        self.productId = productId
        super.init()
        AppModel.shared.subscribeForChanges(self.modelDidChange)
        loadData()
    }
    
    /// Called when the main model is changed `externally`. Use it to update this viewmodel with new data.
    private func modelDidChange() {
        updateCallback?()
    }
    
    private func loadData() {
        guard let productId = productId else { return }
        
        AppModel.shared.getProductWithId(productId) { product in
            guard let product = product else { return }
            self.product = product
            
            AppModel.shared.getARFileWith(firestoreUrl: product.modelData.sceneFile, localFileUrl: FileManager.documentUrl(with: "\(productId)/scene.scn")!) { url in
                guard let url = url else { return }
                self.sceneFileLocalUrl = url
                self.updateCallback?()
            }
            
            var i = 0
            self.textureLocalUrls.removeAll()
            
            for textureUrl in product.modelData.textures {
                AppModel.shared.getARFileWith(firestoreUrl: textureUrl, localFileUrl: FileManager.documentUrl(with: "\(productId)/texture-\(i).png")!) { url in
                    guard let url = url else { return }
                    self.textureLocalUrls.append(url)
                    self.updateCallback?()
                }
                i += 1
            }
        }
    }
    
    // MARK: - Properties
    
    private var productId: String? = nil
    public var product: Product? = nil
    
    private var sceneFileLocalUrl: URL? = nil
    private var textureLocalUrls: [URL] = []
    
    // MARK: - ViewModel Interface
    
    public var sceneFileUrl: URL? {
        return sceneFileLocalUrl
    }
    
    public var textureUrls: [URL] {
        return textureLocalUrls
    }
    
    public var isModelLoaded: Bool {
        guard let product = product else { return false }
        
        return product.modelData.textures.count == textureUrls.count && sceneFileUrl != nil
    }
}

