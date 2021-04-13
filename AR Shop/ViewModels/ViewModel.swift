//
//  ViewModel.swift
//  AR Shop
//
//  Created by Neel Mewada on 10/04/21.
//

import UIKit

class ViewModel {
    internal var updateCallback: (() -> ())?
    
    func setUpdateCallback(_ callback: @escaping () -> ()) {
        self.updateCallback = callback
    }
}
