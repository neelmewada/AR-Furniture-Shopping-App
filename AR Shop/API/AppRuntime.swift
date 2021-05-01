//
//  AppRuntime.swift
//  AR Shop
//
//  Created by Neel Mewada on 24/04/21.
//

import Foundation
import UIKit

class AppRuntime {
    public static weak var navigationController: UINavigationController? = nil
    
    public static var topViewController: UIViewController? {
        return navigationController?.topViewController
    }
    
    public static func showYesNoAlert(title: String, message: String, options: (String, String) = ("Yes", "No"), yesHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: options.1, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: options.0, style: .default, handler: yesHandler))
        Self.topViewController?.present(alert, animated: true)
    }
    
    public static func showAlert(title: String, message: String, buttonTitle: String = "Ok") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        Self.topViewController?.present(alert, animated: true)
    }
    
    public static func pushToNavigation(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public static func popFromNavigation(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    public static func presentModally(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        topViewController?.present(viewController, animated: animated, completion: completion)
    }
}
