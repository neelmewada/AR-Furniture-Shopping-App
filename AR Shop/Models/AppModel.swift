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
    
    /// Used to load the basic data like trending products, user data, etc on app startup
    func loadInitialData() {
        db.collection("products").whereField("isTrending", isEqualTo: true).getDocuments() { querySnapshot, error in
            if let error = error {
                print("[Firebase Error] Error getting products. \(error.localizedDescription)")
                return
            }
            self.trendingProducts.removeAll()
            for document in querySnapshot!.documents {
                if let data = (try? document.data(as: Product.self)) {
                    self.trendingProducts.append(data)
                    self.loadedProducts[data.id!] = data
                }
            }
            
            self.subscribers.raise()
        }
        
        loadUserData()
    }
    
    func subscribeForChanges(_ handler: @escaping Event.EventHandler) {
        subscribers.addHandler(handler)
    }
    
    // MARK: - Properties
    
    var trendingProducts: [Product] = []
    
    /// A run-time cache containing all the products that are loaded since the app startup
    var loadedProducts: [String: Product] = [String: Product]() // dictionary [productId: Product]
    
    var productsInCart: [String: CartProductInfo] = [String: CartProductInfo]() // dictionary [productId: CartProductInfo]
    
    var userData: UserData? = nil
    
    // MARK: - Product Methods
    
    /// Gets the product with ID from cache if it's cached or fetches it from Firebase
    func getProductWithId(_ productId: String, result: @escaping (Product?) -> ()) {
        if let product = loadedProducts[productId] {
            result(product)
            return
        }
        
        db.collection("products").document(productId).getDocument() { querySnapshot, error in
            if let error = error {
                print("[Firebase Error] Error getting product with id \(productId).\n \(error.localizedDescription)")
                result(nil)
                return
            }
            guard let product = (try? querySnapshot?.data(as: Product.self)) else {
                print("[Firebase Error] Error converting JSON data into Product struct.")
                result(nil)
                return
            }
            self.loadedProducts[product.id!] = product
            result(product)
        }
    }
}

// MARK: - Cart Management

extension AppModel {
    func printAllProductsInCart() {
        for product in productsInCart.values {
            print("\(product.productReference.productName)")
        }
    }
    
    func productExistsInCart(_ productId: String) -> Bool {
        return productsInCart.keys.contains(productId)
    }
    
    func canAddProductToCart(_ productId: String) -> Bool {
        return !productExistsInCart(productId)
    }
    
    private func addProductToCart(_ product: Product, _ amount: Int, _ colorIndex: Int = 0, fireEvent: Bool = true) {
        guard let productId = product.id else {
            print("[Error] Product ID is nil")
            return
        }
        if !canAddProductToCart(productId) {
            print("[Error] Can't add product with id \(productId). Maybe the product already exists in cart!")
            return
        }
        productsInCart[productId] = CartProductInfo(id: productId, amount: amount, colorIndex: colorIndex, productReference: product)
        if fireEvent {
            subscribers.raise()
        }
    }
    
    func removeProductFromCart(_ product: Product, fireEvent: Bool = true) {
        guard let productId = product.id else {
            print("[Error] Product ID is nil")
            return
        }
        productsInCart.removeValue(forKey: productId)
        
        if fireEvent {
            subscribers.raise()
        }
    }
    
    func setAmountForProductInCart(_ product: Product, amount: Int, fireEvent: Bool = true, debugInfo: String = "") {
        guard let productId = product.id else {
            print("[Error] Product ID is nil")
            return
        }
        
        if !productExistsInCart(productId) && amount > 0 {
            addProductToCart(product, amount, fireEvent: fireEvent)
            return
        }
        if amount <= 0 {
            removeProductFromCart(product, fireEvent: fireEvent)
            return
        }
        productsInCart[productId]?.amount = amount
        if fireEvent {
            subscribers.raise()
        }
    }
}

// MARK: - User Management

extension AppModel {
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var isUserSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func logoutUser() {
        let _ = try? Auth.auth().signOut()
        userData = nil
    }
    
    /// Loads user document of currently logged in user
    func loadUserData() {
        guard let currentUser = currentUser else { return }
        db.collection("users").document(currentUser.uid).getDocument() { [weak self] querySnapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("[Firebase Error] Error loading current user document. \(error.localizedDescription)")
                return
            }
            guard let userDoc = (try? querySnapshot?.data(as: UserData.self)) else {
                print("[Error in loadUserData()] Error converting JSON data into UserData struct.")
                return
            }
            self.userData = userDoc
            self.subscribers.raise()
        }
    }
    
    func loginUser(email: String, password: String, completion: ((Error?) -> ())?) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                print("[Firebase Error] Failed to login user. \(error.localizedDescription)")
                completion?(error)
                return
            }
            guard let authResult = authResult else { return }
            
            self.db.collection("users").document(authResult.user.uid).getDocument() { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("[Firebase Error] Error getting user document. \(error.localizedDescription)")
                    completion?(error)
                    return
                }
                guard let userDoc = (try? querySnapshot?.data(as: UserData.self)) else {
                    print("[Error in loginUser()] Error converting JSON data into UserData struct.")
                    completion?(CustomError.jsonError)
                    return
                }
                self.userData = userDoc
                completion?(nil)
            }
        }
    }
    
    func registerUser(email: String, fullname: String, password: String, completion: ((Error?) -> ())?) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                print("[Firebase Error] Failed to create user. \(error.localizedDescription)")
                completion?(error)
                return
            }
            guard let authResult = authResult else { return }
            
            let changeRequest = authResult.user.createProfileChangeRequest()
            changeRequest.displayName = fullname
            changeRequest.commitChanges { error in
                completion?(nil)
                guard let error = error else { return }
                print("[Firebase Error] Couldn't commit user's displayName to FirebaseAuth. \(error.localizedDescription)")
            }
            
            self.db.collection("users").document(authResult.user.uid).setData([
                "favorites": [String](),
                "gender": "male",
                "phone": "",
                "country": ""
            ]) { error in
                if let error = error {
                    print("[Firebase Error] Couldn't create a user document. \(error.localizedDescription)")
                    return
                }
                
                self.userData = UserData(id: authResult.user.uid, gender: "male", favorites: [], phone: "", country: "")
                self.subscribers.raise()
            }
        }
    }
}

enum CustomError: Error {
    case jsonError
}
