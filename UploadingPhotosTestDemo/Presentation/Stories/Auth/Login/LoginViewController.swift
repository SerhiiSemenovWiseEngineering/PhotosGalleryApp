//
//  LoginViewController.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login"
    }
}
