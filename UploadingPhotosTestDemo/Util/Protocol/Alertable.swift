//
//  Alertable.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import Foundation
import UIKit

protocol Alertable: AnyObject {
    func displayError(_ error: String, handler: ((UIAlertAction) -> Void)?)
}

extension Alertable where Self: UIViewController {
    
    func displayError(_ error: String, handler: ((UIAlertAction) -> Void)? = nil) {
        displayMessage("", msg: error,
                       actions: nil, handler: handler)
    }

    func displayMessage(_ title: String,
                        msg: String?,
                        actions: UIAlertAction?...,
        handler: ((UIAlertAction) -> Void)?,
                        style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: style)
        if actions.isEmpty || (actions.count == 1 && actions[0] == nil) {
            let dismissAction = UIAlertAction(title: "OK", style: .default, handler: handler)
            alertController.addAction(dismissAction)
        } else {
            for action in actions {
                guard let act = action else { return }
                alertController.addAction(act)
            }
        }
        setupAppearance(for: alertController)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Appearence
extension Alertable {

    // Used as UIApperance protocol cannot be conformed by UIAlertController
    private func setupAppearance(for controller: UIAlertController) {
        controller.view.tintColor = UIColor.gray
    }
}
