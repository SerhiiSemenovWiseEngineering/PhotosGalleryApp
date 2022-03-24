//
//  FIRFirebaseAuthService.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import Foundation
import FirebaseAuth

struct FIRFirebaseAuthService {
    
    static func logoutUser() {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
    }
}
