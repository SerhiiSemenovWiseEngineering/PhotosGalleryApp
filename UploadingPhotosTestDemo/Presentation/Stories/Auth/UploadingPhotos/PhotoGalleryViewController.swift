//
//  UploadingPhotosViewController.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import UIKit
import FirebaseAuth

class PhotoGalleryViewController: UIViewController, Alertable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    // MARK: - Properties
    var images: [UIImage] = []
    var handler: AuthStateDidChangeListenerHandle?
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 2,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    )
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        handler = Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                AuthRouter.showLoginVC(from: self)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let handler = handler else { return }
        
        Auth.auth().removeStateDidChangeListener(handler)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureVM()
        configureRX()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        
        configureCollectionView()
        navigationBar()
        configureDelegates()
    }
    
    // MARK: - Configure VM
    private func configureVM() {
        
    }
    
    private func configureRX() {
        
    }
    
    // MARK: Functions
    private func configureDelegates() {
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
    }
    
    private func configureCollectionView() {
        photosCollectionView.collectionViewLayout = columnLayout
        photosCollectionView.contentInsetAdjustmentBehavior = .always
        photosCollectionView.register(GalleryCollectionViewCell.nib, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier)
    }
    
    private func navigationBar() {
        title = "Photo Galery"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let gearImage = UIImage(systemName: "gear")
        let addImage = UIImage(systemName: "plus")
        let uploadImage = UIImage(systemName: "icloud.and.arrow.up")
        
        let systemButton = UIBarButtonItem(image: gearImage,  style: .plain, target: self, action: #selector(didTapSystemButton(sender:)))
        let addButton   = UIBarButtonItem(image: addImage,  style: .plain, target: self, action: #selector(didTapAddButton(sender:)))
        let uploadButton  = UIBarButtonItem(image: uploadImage,  style: .plain, target: self, action: #selector(didTapUploadButton(sender:)))
        
        navigationItem.rightBarButtonItems = [uploadButton, addButton]
        navigationItem.leftBarButtonItems = [systemButton]
    }
    
    @objc func didTapSystemButton(sender: AnyObject) {
        let alertAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            FIRFirebaseAuthService.shared.logoutUser()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        displayMessage("Preferences", msg: nil, actions: alertAction, cancelAction, handler: nil)
    }
    
    @objc func didTapAddButton(sender: AnyObject) {
        if #available(iOS 14, *) {
            ImagePicker.shared.presentPickerViewController(from: self, errorMessage: { [weak self] in
                guard let self = self else { return }
                self.displayError("You need to allow access to all photos in Settings")
            })
            ImagePicker.shared.delegate = self
        } else {
            displayError("Need to be higher than 14 iOS version")
        }
    }
    
    @objc func didTapUploadButton(sender: AnyObject) {
        print("Upload")
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell() }
        
        let image = images[indexPath.row]
//        let image = catImage.resizeImage(targetSize: CGSize(width: 100, height: 100))
        cell.mainImageView.contentMode = .scaleAspectFit
        cell.mainImageView.image = image
        cell.nameLabel.text = "My home cat"
        
        return cell
    }
}

extension PhotoGalleryViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        
        DispatchQueue.main.async {
            guard let image = image else { return }
            self.images.append(image)
            self.photosCollectionView.reloadData()
        }
    }
}
