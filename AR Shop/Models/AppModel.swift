//
//  AppModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 13/04/21.
//

import UIKit

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

/// The root model class for the app
final class AppModel {
    // MARK: - Lifecycle
    
    public let db: Firestore
    public let storage: Storage
    
    private var subscribers: Event = Event()
    
    private static var _shared: AppModel? = nil
    
    public static var shared: AppModel {
        if _shared == nil {
            _shared = AppModel()
        }
        return _shared!
    }
    
    /// Call this to initialize the singleton instance
    public static func initShared() {
        let _ = Self.shared // initializes the singleton instance
    }
    
    private init() {
        self.db = Firestore.firestore()
        self.storage = Storage.storage()
        loadInitialData()
    }
    
    /// Used to load the basic data like trending products, user settings, etc for initial use
    func loadInitialData() {
        print("Loading Data...")
        db.collection("products").getDocuments() { querySnapshot, error in
            if let error = error {
                print("[Firebase Error] Error getting products: \(error.localizedDescription)")
                return
            }
            self.trendingProducts.removeAll()
            for document in querySnapshot!.documents {
                let data = (try! document.data(as: Product.self))!
                self.trendingProducts.append(data)
                self.loadedProducts[data.id!] = data
            }
            
            self.subscribers.raise()
        }
    }
    
    // MARK: - Properties
    
    var trendingProducts: [Product] = []
    
    /// A run-time cache containing all the products that are loaded from the app startup
    var loadedProducts: [String: Product] = [String: Product]() // dictionary [uuid: Product]
    
    // MARK: - Helpers
    
    func subscribeForChanges(_ handler: @escaping Event.EventHandler) {
        subscribers.addHandler(handler)
    }
}
