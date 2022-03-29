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
typealias ImagesBlock = ([UIImage]) -> Void

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
    
    func getAllImagesFromGallery(completion: @escaping ImagesBlock, errorMessage: @escaping GenericBlock) {
        requestImagePermission (success: { [weak self] in
            guard let self = self else { return }
            self.requestImages(completion: completion)
        }, error: errorMessage)
    }
    
    private func requestImages(completion: @escaping ImagesBlock) {
        
        var images = [UIImage]()
        
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for index in 0..<results.count {
                let asset = results.object(at: index)
                let size = CGSize(width: 700, height: 700)
                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
                    if let image = image {
                        images.append(image)
                    } else {
                        print("error asset to image")
                    }
                    
                    if images.count == results.count {
                        completion(images)
                    }
                }
            }
        } else {
            print("no photos to display")
        }
    }
    
    private func requestImagePermission(success: @escaping GenericBlock, error: @escaping GenericBlock) {
        let cameraAuthStatus: PHAuthorizationStatus!
        cameraAuthStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch cameraAuthStatus {
        case .authorized:
            success()
        case .limited:
            success()
        case .denied:
            error()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { (status) in
                if status == .authorized {
                    success()
                } else if status == .limited {
                    success()
                } else if status == .denied {
                    error()
                }
            })
        default:
            print("None")
        }
    }
    
    private func generatePickerViewController(from viewController: UIViewController) {
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
