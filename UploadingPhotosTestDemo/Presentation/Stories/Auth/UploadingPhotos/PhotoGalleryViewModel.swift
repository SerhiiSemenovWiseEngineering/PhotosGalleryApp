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
    var galeryImages: [GalleryImage] = []
    
    // MARK: - Outputs
    var updateUI = BehaviorRelay<Void>(value: ())
    var isLoading = BehaviorRelay<Bool>(value: false)
    var uploadingErrorHandling: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    // MARK: - Functions
    func appendImageToArray(image: UIImage) {
        let galeryImage = GalleryImage(image: image)
        galeryImages.append(galeryImage)
        updateUI.accept(())
    }
    
    func uploadToFireBase() {
        HUD.show(.progress)
        
        galeryImages
            .filter { !$0.isLoaded }
            .enumerated()
            .forEach { index, imageGalery in
                
                guard let path = Auth.auth().currentUser?.uid else { return }
                let reference = FIRFirestoreStorageService.shared.reference(to: "\(path)/", name: imageGalery.name)
                guard let data = imageGalery.image.jpegData(compressionQuality: 0.7) else { return }
                reference.putData(data, metadata: nil) { [weak self] metadata, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        self.uploadingErrorHandling.accept(error.localizedDescription)
                        HUD.hide()
                    }
                    
                    if let i = self.galeryImages.firstIndex(where: { $0.name == imageGalery.name}) {
                        self.galeryImages[i].isLoaded.toggle()
                        self.updateUI.accept(())
                    }
                    
                    if self.galeryImages.filter({!$0.isLoaded }).count == 0 {
                        HUD.hide()
                    }
                }
            }
    }
    
    func clearData() {
        galeryImages = []
        updateUI.accept(())
    }
}
