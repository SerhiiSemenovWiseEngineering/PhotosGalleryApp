//
//  ImagePicker.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 25.03.2022.
//

import Foundation
import Photos
import UIKit

typealias GenericBlock = () -> Void
typealias ImagesBlock = ([UIImage]) -> Void
typealias ErrorBlock = (String?) -> Void

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

class ImagePicker: NSObject {
    weak var delegate: ImagePickerDelegate?
    
    private override init() {}
    static let shared = ImagePicker()
    
    func getAllImagesFromGallery(completion: @escaping ImagesBlock, errorMessage: @escaping ErrorBlock) {
        requestImagePermission (success: { [weak self] in
            guard let self = self else { return }
            self.requestImages(completion: completion, error: errorMessage)
        }, error: errorMessage)
    }
    
    private func requestImages(completion: @escaping ImagesBlock, error: @escaping ErrorBlock) {
        
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
            error("No photos to display")
        }
    }
    
    private func requestImagePermission(success: @escaping GenericBlock, error: @escaping ErrorBlock) {
        let authStatus: PHAuthorizationStatus!
        if #available(iOS 14, *) {
            authStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            authStatus = PHPhotoLibrary.authorizationStatus()
        }
        switch authStatus {
        case .authorized:
            success()
        case .limited:
            success()
        case .denied:
            error("You need to allow access to all photos in Settings")
        case .notDetermined:
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { (status) in
                    if status == .authorized {
                        success()
                    } else if status == .limited {
                        success()
                    } else if status == .denied {
                        error("You need to allow access to all photos in Settings")
                    }
                })
            } else {
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == .authorized {
                        success()
                    }
                    else {
                        error("You need to allow access to all photos in Settings")
                    }
                })
            }
        default:
            print("None")
        }
    }
}
