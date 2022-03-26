//
//  PhotoGalleryViewModel.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 25.03.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import PKHUD
import FirebaseAuth

class PhotoGalleryViewModel {
    
    // MARK: - Properties
    private var galeryImagesValue: [GalleryImage] = []
    
    // MARK: - Outputs
    var galeryImages = BehaviorRelay<[GalleryImage]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Functions
    func appendImageToArray(image: UIImage) {
        let galeryImage = GalleryImage(image: image)
        galeryImagesValue.append(galeryImage)
        galeryImages.accept(galeryImagesValue)
    }
    
    func uploadToFireBase() {
        var counter = 0
        HUD.show(.progress)
        
        galeryImages.value
            .filter { $0.isLoaded != false }
            .enumerated()
            .forEach { index, imageGalery in
                
                let reference = FIRFirestoreStorageService.shared.reference(to: "images/", name: imageGalery.name)
                guard let data = imageGalery.image.jpegData(compressionQuality: 0.7) else { return }
                reference.putData(data, metadata: nil) { [weak self] metadata, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print(error)
                        HUD.hide()
                    }
                    
                    self.galeryImagesValue[index].isLoaded.toggle()
                    self.galeryImages.accept(self.galeryImagesValue)
                    
                    counter += 1
                    if (counter == self.galeryImages.value.count) {
                        HUD.hide()
                    }
                }
            }
    }
    
    func clearData() {
        galeryImagesValue = []
        galeryImages.accept(galeryImagesValue)
    }
}
