//
//  LoginViewModelConstants.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import Foundation

struct LoginViewModelConstants {
    
    static let regexpEmail = "^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]|[\\w-]{2,}))@((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9]))|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})$"
    
    static let regexPswd = "^.{6,24}$"
}
