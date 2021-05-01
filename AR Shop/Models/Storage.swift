//
//  Storage.swift
//  AR Shop
//
//  Created by Neel Mewada on 30/04/21.
//

import Foundation
import UIKit

extension AppModel {
    
    /// Downloads the file from firestore URL and updates the cache. Calls completion with local file url if successful.
    func downloadARFileWith(firestoreUrl: String, localFileUrl: URL, completion: ((URL?) -> ())? = nil) {
        let fileRef = storage.reference(forURL: firestoreUrl)
        
        let _ = fileRef.write(toFile: localFileUrl) { [weak self] url, error in
            guard let self = self else { return }
            if let error = error {
                print("[Firebase Error] Error downloading file with Firestore URL: \(firestoreUrl).\n \(error)")
                completion?(nil)
                return
            }
            completion?(url)
            let pathComponents = url!.path.split(separator: "/")
            self.downloadsCache[firestoreUrl] = "\(pathComponents[pathComponents.count - 2])/\(pathComponents.last!)"
            self.downloadsCache.storePersistently()
        }
    }
    
    /// Returns the locally cached file if it exists. If it doesn't, then it downloads the file from firestore. Calls completion with local file url if successful.
    func getARFileWith(firestoreUrl: String, localFileUrl: URL, completion: ((URL?) -> ())? = nil) {
        
        // Return if file exists locally (cached)
        if let localFileUrl = self.downloadsCache[firestoreUrl] {
            let fullUrl = FileManager.documentUrl(with: localFileUrl)!
            completion?(fullUrl)
            return
        }
        
        downloadARFileWith(firestoreUrl: firestoreUrl, localFileUrl: localFileUrl, completion: completion)
    }
    
}
