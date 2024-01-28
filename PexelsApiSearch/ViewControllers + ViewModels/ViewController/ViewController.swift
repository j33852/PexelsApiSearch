//
//  ViewController.swift
//  PexelsApiSearch
//
//  Created by Chun Chieh Chang on 2024/01/26.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class ViewController: UIViewController {
    
    private let photoViewModel = ViewControllerViewModel()   

    private let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var photoCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCollectionViewLayout()
        setupViewModel()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBar.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewLayout()
    }

    private func updateCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        let cellWidth = (photoCollectionView.bounds.size.width - 2 * flowLayout.minimumLineSpacing) / 2.0
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ])
        
        photoCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
}

// MARK: Set ViewModel
extension ViewController {
    private func setupViewModel() {
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                            self?.photoViewModel.searchButtonClicked.onNext(self?.searchBar.text ?? "")
                        })
            .disposed(by: photoViewModel.bag)
        
        photoViewModel.photos
                    .bind(to: photoCollectionView.rx.items(cellIdentifier: CollectionViewCell.CELL_IDENTIFIER, cellType: CollectionViewCell.self)) { _, photo, cell in
                        cell.imageView?.sd_setImage(with: photo.thumbUrl(), completed: nil)
                        cell.label.text = photo.photographer
                    }
                    .disposed(by: photoViewModel.bag)
        
    
        
        Observable.zip(photoCollectionView.rx.itemSelected, photoCollectionView.rx.modelSelected(Photo.self)).subscribe(onNext: { [unowned self] indexPath, photo in
            self.showPreview(photo: photo, at: indexPath)
        }).disposed(by: photoViewModel.bag)
        
        
        photoCollectionView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] _, indexPath in
                self?.photoViewModel.willDisplayCell(at: indexPath)
            })
            .disposed(by: photoViewModel.bag)
        
        photoViewModel.isRequesting
                    .subscribe(onNext: { [weak self] requesting in
                        self?.loadingView.isHidden = !requesting
                        if requesting {
                            self?.loadingIndicator.isHidden = false
                            self?.loadingIndicator.startAnimating()
                        } else {
                            self?.loadingIndicator.isHidden = true
                        }
                    })
                    .disposed(by: photoViewModel.bag)
    }
}



// MARK: View flow
extension ViewController {
    private func showPreview(photo: Photo, at indexPath: IndexPath) {
        guard let previewNav = storyboard?.instantiateViewController(withIdentifier: "PreviewNav") as? UINavigationController,
              let previewVC = previewNav.topViewController as? PreviewViewController
          else { return }

        previewVC.photo = photo

        self.present(previewNav, animated: true, completion: nil)
    }
}

