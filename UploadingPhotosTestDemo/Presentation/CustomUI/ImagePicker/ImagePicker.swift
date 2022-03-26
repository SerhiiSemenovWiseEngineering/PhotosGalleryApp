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

typealias GenericBlock = () -> Void

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

class ImagePicker: NSObject {
    weak var delegate: ImagePickerDelegate?
    
    private override init() {}
    static let shared = ImagePicker()
    
    func presentPickerViewController(from viewController: UIViewController, errorMessage: @escaping GenericBlock) {
        requestImagePermission(success: { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.generatePickerViewController(from: viewController)
            }
            
        }, error: errorMessage)
    }
    
    func requestImagePermission(success: @escaping GenericBlock, error: @escaping GenericBlock) {
        let cameraAuthStatus: PHAuthorizationStatus!
        if #available(iOS 14, *) {
            cameraAuthStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            cameraAuthStatus = PHPhotoLibrary.authorizationStatus()
        }
        switch cameraAuthStatus {
        case .authorized:
            success()
        case .limited:
            success()
        case .denied:
            error()
        case .notDetermined:
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { (status) in
                    if status == .authorized {
                        success()
                    } else if status == .limited {
                        success()
                    } else if status == .denied {
                        error()
                    }
                })
            }
            else {
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == .authorized {
                        success()
                    } else if status == .limited {
                        success()
                    } else if status == .denied {
                        error()
                    }
                })
            }
        default:
            print("None")
        }
    }
    
    func generatePickerViewController(from viewController: UIViewController) {
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
