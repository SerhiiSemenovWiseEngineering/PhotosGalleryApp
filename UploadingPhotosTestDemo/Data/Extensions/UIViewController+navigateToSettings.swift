//
//  UIViewController+navigateToSettings.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 04.04.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func settingsAction() -> UIAlertAction {
        return UIAlertAction(title: "Settings", style: .default) { _ in
            self.navigateToSettings()
        }
    }
    
    private func navigateToSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}
