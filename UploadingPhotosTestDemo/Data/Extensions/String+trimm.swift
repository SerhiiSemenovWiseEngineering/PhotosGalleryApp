//
//  String+trimm.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import Foundation
import Foundation

extension String {
    func trimm() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
