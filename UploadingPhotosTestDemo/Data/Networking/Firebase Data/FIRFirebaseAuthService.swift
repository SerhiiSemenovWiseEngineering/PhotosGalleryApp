//
//  FIRFirebaseAuthService.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import Foundation
import FirebaseAuth

struct FIRFirebaseAuthService {
    
    private init() {}
    static let shared = FIRFirebaseAuthService()
    
    func logoutUser() {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
    }
}
