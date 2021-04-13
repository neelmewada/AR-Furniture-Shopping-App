//
//  HeroSectionViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 10/04/21.
//

import UIKit

class HeroSectionViewModel: ViewModel {
    
    // MARK: - Getters
    
    var heroImage: UIImage {
        return UIImage(named: "sofa-3")!
    }
    
    var heroTitle: String {
        return "Make yourself at home"
    }
    
    var heroSubtitle: String {
        return "We love clean design and natural furniture solutions."
    }
}
