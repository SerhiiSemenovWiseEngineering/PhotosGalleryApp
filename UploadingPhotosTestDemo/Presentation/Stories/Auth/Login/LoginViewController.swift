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
        
        configureUI()
        configureVM()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        
        configureEmailAndPasswordTextField()
        configureScreen()
        navigationBar()
        configureLoginButton()
    }
    
    private func navigationBar() {
        title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureLoginButton() {
        signInButton.layer.cornerRadius = 0.02 * signInButton.bounds.size.width
    }
    
    private func configureScreen() {
        isModalInPresentation = true
    }
    
    private func configureEmailAndPasswordTextField() {
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
    }
    
    // MARK: - Configure VM
    private func configureVM() {
        loginWithEmail()
        
        loginViewModel.enableButton?
            .bind { [weak self] isEnabled in
                guard let self = self else { return }
                self.signInButton.backgroundColor = isEnabled ? UIColor.link : UIColor.lightGray
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
    
    private func loginWithEmail() {
        loginViewModel.signInWithEmail(email: emailTextField.rx.text.asObservable(),
                                       password: passwordTextField.rx.text.asObservable(),
                                       didPressSignInButton: signInButton.rx.tap.asObservable())
        
        loginViewModel.isSignedInViaEmail
            .skip(1)
            .bind { [weak self] (succes, user, error) in
                guard let self = self else { return }
                if succes {
                    self.dismiss(animated: true)
                } else {
                    self.displayMessage("Error", msg: error?.localizedDescription, handler: nil)
                }
            }
            .disposed(by: disposeBag)
    }
}
