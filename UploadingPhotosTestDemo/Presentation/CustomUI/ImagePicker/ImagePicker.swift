//
//  ImagePicker.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 25.03.2022.
//

import Foundation
import PhotosUI
import Photos
import UIKit

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

class ImagePicker: NSObject {
    weak var delegate: ImagePickerDelegate?
    
    private override init() {}
    static let shared = ImagePicker()
    
    func presentPickerViewController(from viewController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = 0
        configuration.preferredAssetRepresentationMode = .current
     
        let photoPickerViewController = PHPickerViewController(configuration: configuration)
        photoPickerViewController.delegate = self
        viewController.present(photoPickerViewController, animated: true)
    }
}

extension ImagePicker: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProviders = results.map(\.itemProvider)

        for itemProvider in itemProviders {
            itemProvider.loadDataRepresentation(forTypeIdentifier: "public.image") { [unowned self] data, error in
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                
                self.delegate?.didSelect(image: image)
            }
        }
    }
}
