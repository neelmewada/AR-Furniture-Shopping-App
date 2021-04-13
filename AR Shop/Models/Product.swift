//
//  Product.swift
//  AR Shop
//
//  Created by Neel Mewada on 10/04/21.
//

import Foundation
import UIKit

struct Product {
    let productId: Int
    var productName: String
    var imageUrl: String
    var price: Float
    var category: String
    var isFavorite: Bool
    
    var productDescription: String
    
    var image: UIImage {
        return UIImage(named: imageUrl)!
    }
}
