//
//  LoginViewModel.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import Foundation
import RxSwift
import RxCocoa
import PKHUD
import FirebaseAuth

class LoginViewModel {
    
    // MARK: - Outputs
    var isSignedInViaEmail: BehaviorRelay<(Bool, AuthDataResult?, Error?)> = BehaviorRelay(value: (false, nil, nil))
    var loginErrorHandling: BehaviorRelay<String> = BehaviorRelay(value: "")
    var enableButton: Observable<Bool>?
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    init() {}
        
    // MARK: Functions
    func signInWithEmail(email: Observable<String?>,
                         password: Observable<String?>,
                         didPressSignInButton: Observable<Void>) {
        
        let userInputs = Observable.combineLatest(email, password) { (login, password) -> (String, String) in

            guard let unwrapedLogin = login?.trimm(),
                  let unwrapedPassword = password else {
                return ("", "")
            }

            return (unwrapedLogin, unwrapedPassword)
        }

        let loginValidation = email
            .map({!$0!.isEmpty})
            .share(replay: 1)

        let passwordValidation = password
            .map({!$0!.isEmpty})
            .share(replay: 1)

        enableButton = Observable.combineLatest(loginValidation, passwordValidation) { (login, name) in
            return login && name
        }

        didPressSignInButton
            .withLatestFrom(userInputs)
            .bind { [weak self] (login, password) in
                guard let self = self else { return }
                HUD.show(.progress)

                guard login.count > 0 else {
                    self.loginErrorHandling.accept("You havent tiped email")
                    HUD.hide()
                    return
                }

                guard login.contains("@") else {
                    HUD.hide()
                    self.loginErrorHandling.accept("You forgot to tipe \"@\"")

                    return
                }

                guard login.range(of: LoginViewModelConstants.regexpEmail, options: .regularExpression, range: nil, locale: nil) != nil else {
                    HUD.hide()
                    self.loginErrorHandling.accept("The email typed incorrectly")

                    return
                }

                guard password.range(of: LoginViewModelConstants.regexPswd, options: .regularExpression) != nil else {
                    HUD.hide()
                    self.loginErrorHandling.accept("Your password should be min 6 max 24 symbols")

                    return
                }

                guard password.count > 0 else {
                    self.loginErrorHandling.accept("You havent tiped password")
                    HUD.hide()
                    return
                }

                Auth.auth().signIn(withEmail: login, password: password) { [unowned self] (user, error) in
                    HUD.hide()
                    self.isSignedInViaEmail.accept((user != nil, user, error))
                }
            }
            .disposed(by: disposeBag)
    }
}
