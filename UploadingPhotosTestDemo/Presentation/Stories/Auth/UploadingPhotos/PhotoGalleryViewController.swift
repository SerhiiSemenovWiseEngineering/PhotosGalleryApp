//
//  UploadingPhotosViewController.swift
//  UploadingPhotosTestDemo
//
//  Created by Serhii Semenov on 24.03.2022.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class PhotoGalleryViewController: UIViewController, Alertable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    // MARK: - Properties
    private var photoGalleryViewModel = PhotoGalleryViewModel()
    private var handler: AuthStateDidChangeListenerHandle?
    private let disposeBag = DisposeBag()
    
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 2,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    )
    
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        handler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            if user == nil {
                AuthRouter.showLoginVC(from: self)
                self.photoGalleryViewModel.clearData()
            } else {
                self.getImagesFromLibrary()
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
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        
        configureCollectionView()
        navigationBar()
        configureDelegates()
    }
    
    // MARK: - Configure VM
    private func configureVM() {
        photoGalleryViewModel.updateUI
            .bind { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.photosCollectionView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        photoGalleryViewModel.uploadingErrorHandling
            .skip(1)
            .bind { [weak self] (error) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.displayMessage("Error", msg: error, handler: nil)
                }
            }
            .disposed(by: disposeBag)
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
    
    private func getImagesFromLibrary() {
        ImagePicker.shared.getAllImagesFromGallery { images in
            self.photoGalleryViewModel.appendImagesToArray(images: images)
        } errorMessage: { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    let settingsAction = self.settingsAction()
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    self.displayMessage("Important",
                                        msg: error,
                                        actions: settingsAction,
                                        cancelAction,
                                        handler: nil,
                                        style: .alert)
                }
            }
        }
    }
    
    private func navigationBar() {
        title = "Photo Gallery"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let gearImage = UIImage(systemName: "gear")
        let systemButton = UIBarButtonItem(image: gearImage,  style: .plain, target: self, action: #selector(didTapSystemButton(sender:)))
        
        navigationItem.rightBarButtonItems = [systemButton]
    }
    
    @objc func didTapSystemButton(sender: AnyObject) {
        let alertAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            FIRFirebaseAuthService.shared.logoutUser()
        }
        let settingsAction = self.settingsAction()
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        displayMessage("Preferences", msg: nil, actions: settingsAction, alertAction, cancelAction, handler: nil, style: .actionSheet)
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoGalleryViewModel.galeryImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier, for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell() }
        
        let galeryImage = photoGalleryViewModel.galeryImages[indexPath.row]
        cell.configure(galeryImage: galeryImage)
        
        return cell
    }
}
