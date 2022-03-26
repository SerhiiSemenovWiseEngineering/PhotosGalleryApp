//
//  GalleryImage.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 25.03.2022.
//

import Foundation
import UIKit

struct GalleryImage {
    
    private(set) var name: String
    var isLoaded = false
    var image: UIImage
    
    init(image: UIImage, name: String = UUID().uuidString) {
        self.name = name
        self.image = image
    }
}
