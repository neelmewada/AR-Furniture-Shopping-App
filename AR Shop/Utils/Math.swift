//
//  Math.swift
//  AR Shop
//
//  Created by Neel Mewada on 15/04/21.
//

import Foundation
import UIKit

final class Math {
    static func clamp01(_ value: CGFloat) -> CGFloat {
        return max(0, min(1, value))
    }
    
    static func clamp(_ value: CGFloat, _ minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
        return max(minValue, min(maxValue, value))
    }
    
    static func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        let amt = clamp01(t)
        return a * (1 - amt) + b * amt
    }
    
    static func lerpUnclamped(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        let amt = t
        return a * (1 - amt) + b * amt
    }
}
