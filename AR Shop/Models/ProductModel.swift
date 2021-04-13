//
//  ProductModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 10/04/21.
//

import Foundation
import UIKit

final class ProductModel {
    // MARK: - Lifecycle
    
    private static var _shared: ProductModel? = nil
    
    /// Returns the singleton instance of ProductModel that can be used throughout the app
    public static var shared: ProductModel {
        if _shared == nil {
            _shared = ProductModel()
        }
        return _shared!
    }
    
    private init() {
        
    }
    
    func loadData() {
        
    }
    
    // MARK: - Properties
    
    var products: [Product] = [
        Product(productId: 0, productName: "Grey Chair", imageUrl: "sofa-1", price: 12.99, category: "Chair", isFavorite: false, productDescription: "A grey chair"),
        Product(productId: 1, productName: "Red Chair", imageUrl: "sofa-2", price: 6.99, category: "Chair", isFavorite: true, productDescription: "A red chair"),
        Product(productId: 2, productName: "Grey Stool", imageUrl: "sofa-3", price: 9.99, category: "Stool", isFavorite: false, productDescription: "A grey stool"),
        Product(productId: 3, productName: "Grey Stool", imageUrl: "sofa-3", price: 9.99, category: "Stool", isFavorite: false, productDescription: "A grey stool"),
        Product(productId: 4, productName: "Grey Stool", imageUrl: "sofa-3", price: 9.99, category: "Stool", isFavorite: false, productDescription: "A grey stool")
    ]
}
