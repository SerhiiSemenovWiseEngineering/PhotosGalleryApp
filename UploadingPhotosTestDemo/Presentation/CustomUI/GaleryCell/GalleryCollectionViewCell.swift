//
//  GalleryCollectionViewCell.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell, NibLoadable {

    static let reuseIdentifier = "GalleryCollectionViewCell"
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
