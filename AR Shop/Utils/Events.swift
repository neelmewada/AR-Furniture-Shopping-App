//
//  Events.swift
//  AR Shop
//
//  Created by Neel Mewada on 13/04/21.
//

import UIKit

class Event {
    typealias EventHandler = () -> ()
    
    private var eventHandlers = [EventHandler]()
    
    func addHandler(_ handler: @escaping EventHandler) {
        eventHandlers.append(handler)
    }
    
    func removeAllHandlers() {
        eventHandlers.removeAll()
    }
    
    func raise() {
        for handler in eventHandlers {
            handler()
        }
    }
}
