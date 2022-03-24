//
//  AuthRouter.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import Foundation
import UIKit

class AuthRouter {
    
    static func showLoginVC(from viewController: UIViewController) {
        
        let identifier = LoginViewController.identifier
        if let loginVC = UIStoryboard(name: "Auth", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: identifier) as? UINavigationController {
            viewController.present(loginVC, animated: true)
        }
    }
}
