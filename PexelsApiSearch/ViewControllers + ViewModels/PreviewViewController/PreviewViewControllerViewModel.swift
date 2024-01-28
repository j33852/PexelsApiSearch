//
//  PreviewViewControllerViewModel.swift
//  PexelsApiSearch
//
//  Created by Chun Chieh Chang on 2024/01/26.
//

import Foundation
import RxSwift
import RxCocoa
import SDWebImage

class PreviewViewControllerViewModel {

    private let photo: Photo

    init(photo: Photo) {
        self.photo = photo
    }

    func loadPhoto() -> Driver<UIImage?> {
        return Observable.create { observer in
            SDWebImageManager.shared.loadImage(
                with: self.photo.originalPhotoUrl(),
                options: .continueInBackground,
                progress: nil) { (image, _, _, _, _, _) in
                    observer.onNext(image)
                    observer.onCompleted()
            }

            return Disposables.create()
        }
        .asDriver(onErrorJustReturn: nil)
    }
}
