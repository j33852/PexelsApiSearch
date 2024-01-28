//
//  PreviewViewController.swift
//  PexelsApiSearch
//
//  Created by Chun Chieh Chang on 2024/01/26.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class PreviewViewController: UIViewController {
    static let identifier = "PreviewViewController"
    
    private let bag = DisposeBag()
    private var viewModel: PreviewViewControllerViewModel!
    
    var photo: Photo!
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()

    }
    
    
    private func setupViewModel() {
        viewModel = PreviewViewControllerViewModel(photo: photo)
        
        viewModel.loadPhoto()
            .drive(imageView.rx.image)
            .disposed(by: bag)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.black
        
        closeButton.rx.tap
            .subscribe { [unowned self] _ in
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: bag)
    }
 
}
