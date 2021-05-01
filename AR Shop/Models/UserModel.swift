//
//  UserData.swift
//  AR Shop
//
//  Created by Neel Mewada on 25/04/21.
//

import FirebaseFirestoreSwift
import UIKit

// MARK: - UserData

struct UserData: Codable, Identifiable {
    @DocumentID var id: String? = nil
    var gender: String = ""
    var favorites: [String] = []
    var phone: String = ""
    var country: String = ""
    var addresses: [Address] = []
    
    // MARK: - Computed Properties
    
    var genderValue: Gender {
        return Gender(rawValue: gender) ?? .unspecified
    }
}

enum Gender: String, Codable {
    case male = "male"
    case female = "female"
    case unspecified = "unspecified"
    
    static var optionsArray: [String] {
        [Gender.male.rawValue, Gender.female.rawValue, Gender.unspecified.rawValue]
    }
}

struct Address: Codable {
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
}

