//
//  Product.swift
//  AR Shop
//
//  Created by Neel Mewada on 10/04/21.
//

import Foundation
import UIKit
import SDWebImage
import FirebaseFirestoreSwift

struct Product: Codable, Hashable, Identifiable {
    @DocumentID var id: String? = nil
    var productName: String = ""
    var thumbnailUrl: String = ""
    var galleryUrl: String = ""
    var productPrice: Float = 0.0
    var categories: [String] = []
    var colorOptions: [String] = []
    
    var isTrending: Bool = false
    var isFavorite: Bool = false
    var rating: Float = 0.0
    
    var productDescription: String = ""
    
    var thumbnailImage: UIImage {
        return UIImage(named: thumbnailUrl) ?? UIImage()
    }
    
    var galleryImage: UIImage {
        return UIImage(named: galleryUrl) ?? UIImage()
    }
}
