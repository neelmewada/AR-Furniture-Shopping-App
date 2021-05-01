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
    
    private let dataFilePath = FileManager.documentDirectoryUrl?.appendingPathComponent("AppData.plist")

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
        loadProductsInCart()
        downloadsCache.load()
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
    
    var favoriteProducts: [Product] = []
    
    /// Cache containing local URLs of all downloaded files
    var downloadsCache = Cache<String>("Downloads.plist")
}

// MARK: - Product Management

extension AppModel {
    /// Gets the product with ID from cache if it's cached or fetches it from Firebase
    func getProductWithId(_ productId: String, result: @escaping (Product?) -> ()) {
        if let product = loadedProducts[productId] {
            result(product)
            return
        }
        
        db.collection("products").document(productId).getDocument() { documentSnapshot, error in
            if let error = error {
                print("[Firebase Error] Error getting product with id \(productId).\n \(error.localizedDescription)")
                result(nil)
                return
            }
            guard let product = (try? documentSnapshot?.data(as: Product.self)) else {
                print("[Firebase Error] Error converting JSON data into Product struct.")
                result(nil)
                return
            }
            self.loadedProducts[product.id!] = product
            result(product)
        }
    }
    
    func getProductWithId(_ productId: String) -> Product? {
        return loadedProducts[productId]
    }
    
    func getAllProductsWithIds(_ productIds: [String], completion: @escaping ([Product]) -> ()) {
        db.collection("products").whereField(FieldPath.documentID(), in: productIds).getDocuments() { querySnapshot, error in
            if let error = error {
                print("[Firebase Error] Error fetching favorite products.\n \(error.localizedDescription)")
                completion([])
                return
            }
            guard let querySnapshot = querySnapshot else { return }
            var products = [Product]()
            for document in querySnapshot.documents {
                guard let product = (try? document.data(as: Product.self)) else {
                    print("[Error] Couldn't convert Favorite Product document with id \(document.documentID) into Product struct.")
                    continue
                }
                products.append(product)
            }
            completion(products)
        }
    }
    
    func setProductAsFavorite(_ productId: String, favorite: Bool) {
        guard let userData = userData else { return }
        
        let indexInArray = userData.favorites.firstIndex(of: productId)
        
        if favorite && indexInArray == nil {
            self.userData?.favorites.append(productId)
            getProductWithId(productId) { product in
                if let product = product {
                    self.favoriteProducts.append(product)
                }
            }
            pushUserData()
            subscribers.raise()
        } else if !favorite && indexInArray != nil {
            self.userData?.favorites.remove(at: indexInArray!)
            if let index = favoriteProducts.firstIndex(where: { product in
                return product.id == productId
            }) {
                favoriteProducts.remove(at: index)
            }
            pushUserData()
            subscribers.raise()
        }
    }
    
    func isProductFavorite(_ productId: String) -> Bool {
        guard let userData = userData else { return false }
        return userData.favorites.contains(productId)
    }
    
    func loadFavoriteProducts(fireEvent: Bool = true) {
        guard let userData = userData else { return }
        
        if userData.favorites.count == 0 {
            return
        }
        
        getAllProductsWithIds(userData.favorites) { products in
            self.favoriteProducts = products
            if fireEvent {
                self.subscribers.raise()
            }
        }
    }
}

// MARK: - Cart Management

extension AppModel {
    
    func loadProductsInCart() {
        if let data = try? Data(contentsOf: self.dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                productsInCart = try decoder.decode([String: CartProductInfo].self, from: data)
            } catch {
                print("Error decoding AppData.plist. \(error)")
            }
        }
    }
    
    func saveCartProducts() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(productsInCart)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding AppData.plist. \(error)")
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
        
        productsInCart[productId] = CartProductInfo(id: productId, amount: amount, colorIndex: colorIndex)
        saveCartProducts()
        
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
        saveCartProducts()
        
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
        saveCartProducts()
        
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
    
    func pushUserData(completion: ((Error?) -> ())? = nil) {
        guard let currentUser = currentUser else { return }
        guard let userData = userData else { return }
        
        do {
            try db.collection("users").document(currentUser.uid).setData(from: userData) { error in
                if let error = error {
                    print("[Firebase Error] Error pushing user doc to Firestore. \(error.localizedDescription)")
                    completion?(error)
                    return
                }
                completion?(nil)
            }
        } catch let error {
            print("[Error] Error pushing user doc to Firestore. \(error.localizedDescription)")
            completion?(error)
        }
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
            self.loadFavoriteProducts()
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
                self.loadFavoriteProducts()
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
                "country": "",
                "addresses": [Address]()
            ]) { error in
                if let error = error {
                    print("[Firebase Error] Couldn't create a user document. \(error.localizedDescription)")
                    return
                }
                
                self.userData = UserData(id: authResult.user.uid, gender: "male", favorites: [], phone: "", country: "")
                self.favoriteProducts = []
                self.subscribers.raise()
            }
        }
    }
}

enum CustomError: Error {
    case jsonError
}
