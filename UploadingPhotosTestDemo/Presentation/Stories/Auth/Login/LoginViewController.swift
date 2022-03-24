//
//  LoginViewController.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import UIKit
import FirebaseAuth
import RxSwift

class LoginViewController: UIViewController, Alertable {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Properties
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureVM()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        
        loginWithEmail()
        navigationBar()
        configureLoginButton()
    }
    
    // MARK: Functions
        private func loginWithEmail() {
            loginViewModel.signInWithEmail(email: emailTextField.rx.text.asObservable(),
                                          password: passwordTextField.rx.text.asObservable(),
                                          didPressSignInButton: signInButton.rx.tap.asObservable())
            
            loginViewModel.isSignedInViaEmail
                .skip(1)
                .bind { [weak self] (succes, user, error) in
                    guard let self = self else { return }
                    if succes {
                        // Dissmis the login screen
                        print("Logged In")
                    } else {
                        self.displayMessage("Error", msg: error?.localizedDescription, handler: nil)
                    }
                }
                .disposed(by: disposeBag)
        }
    
    private func navigationBar() {
        title = "Login"
    }
    
    private func configureLoginButton() {
        signInButton.layer.cornerRadius = 0.02 * signInButton.bounds.size.width
    }
    
    //MARK: - Configure VM
    private func configureVM() {
        loginViewModel.enableButton?
            .bind { [weak self] isEnabled in
                guard let self = self else { return }
                if isEnabled {
                    self.signInButton.backgroundColor = UIColor.link
                } else {
                    self.signInButton.backgroundColor = UIColor.lightGray
                }
            }
            .disposed(by: disposeBag)
        
        loginViewModel.enableButton?
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginViewModel.loginErrorHandling
            .skip(1)
            .bind { [weak self] (error) in
                guard let self = self else { return }
                self.displayMessage("Error", msg: error, handler: nil)
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        logoutUser()
    }
}

extension LoginViewController {
    func logoutUser() {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
    }
}
