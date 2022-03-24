//
//  UploadingPhotosViewController.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import UIKit
import FirebaseAuth

class UploadingPhotosViewController: UIViewController {
    
    var handler: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        handler = Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                AuthRouter.showLoginVC(from: self)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let handler = handler else { return }
        
        Auth.auth().removeStateDidChangeListener(handler)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logOut(_ sender: UIButton) {
        logoutUser(completion: {
            //AuthRouter.showLoginVC(from: self)
        })
    }
}
