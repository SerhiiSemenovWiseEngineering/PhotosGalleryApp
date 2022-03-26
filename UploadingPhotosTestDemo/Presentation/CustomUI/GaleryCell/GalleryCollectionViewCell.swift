//
//  GalleryCollectionViewCell.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell, NibLoadable {

    // MARK: - Properties
    static let reuseIdentifier = "GalleryCollectionViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var actionIcon: UIImageView!
    
    // MARK: - Functions
    func configure(galeryImage: GalleryImage) {
        mainImageView.layer.opacity = galeryImage.isLoaded ? 0.5 : 1
        actionIcon.image = galeryImage.isLoaded ? UIImage(systemName: "icloud.and.arrow.up") : UIImage(systemName: "")
        
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.image = galeryImage.image
    }
}
