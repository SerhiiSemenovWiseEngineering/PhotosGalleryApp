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
    @IBOutlet weak var nameLabel: UILabel!
}
