//
//  FIRFirebaseStorageService.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import Foundation
import Firebase

class FIRFirestoreStorageService {
    
    private init() {}
    static let shared = FIRFirestoreStorageService()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    func reference(to path: String, name: String) -> StorageReference {
        return Storage.storage().reference().child("\(path)\(name).jpg")
    }
}
