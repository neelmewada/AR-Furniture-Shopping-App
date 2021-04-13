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
    
    func loadAllProducts() {
        let db = AppModel.shared.db
        print("Loading products...")
        db.collection("products").getDocuments() { querySnapshot, error in
            if let error = error {
                print("[Firebase Error] Error getting products: \(error.localizedDescription)")
                return
            }
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
    }
    
    // MARK: - Properties
    
    var products: [Product] = [
        Product(productName: "Grey Chair", thumbnailUrl: "sofa-1", productPrice: 12.99, categories: ["Chair"], isFavorite: false, productDescription: "A grey chair"),
        Product(productName: "Red Chair", thumbnailUrl: "sofa-2", productPrice: 6.99, categories: ["Chair"], isFavorite: true, productDescription: "A red chair"),
        Product(productName: "Grey Stool", thumbnailUrl: "sofa-3", productPrice: 9.99, categories: ["Stool"], isFavorite: false, productDescription: "A grey stool"),
        Product(productName: "Grey Stool", thumbnailUrl: "sofa-3", productPrice: 9.99, categories: ["Stool"], isFavorite: false, productDescription: "A grey stool"),
        Product(productName: "Grey Stool", thumbnailUrl: "sofa-3", productPrice: 9.99, categories: ["Stool"], isFavorite: false, productDescription: "A grey stool"),
    ]
}
