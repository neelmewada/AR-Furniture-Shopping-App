//
//  Cache.swift
//  AR Shop
//
//  Created by Neel Mewada on 30/04/21.
//

import Foundation
import UIKit

class Cache<T: Codable> {
    private var data = [String: T]()
    private let fileName: String
    
    init(_ fileName: String) {
        self.fileName = fileName
    }
    
    subscript(key: String) -> T? {
        get { data[key] }
        set { data[key] = newValue }
    }
    
    func load() -> Bool {
        guard let url = FileManager.documentDirectoryUrl?.appendingPathComponent(fileName) else { return false }
        
        if let data = try? Data(contentsOf: url) {
            let decoder = PropertyListDecoder()
            do {
                self.data = try decoder.decode([String: T].self, from: data)
                return true
            } catch {
                print("Error decoding Cache from \(fileName). \(error)")
            }
        }
        return false
    }
    
    func storePersistently() {
        guard let url = FileManager.documentDirectoryUrl?.appendingPathComponent(fileName) else { return }
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.data)
            try data.write(to: url)
        } catch {
            print("Error encoding Cache to \(fileName). \(error)")
        }
    }
}


