//
//  ViewControllerViewModel.swift
//  PexelsApiSearch
//
//  Created by Chun Chieh Chang on 2024/01/27.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class ViewControllerViewModel {
    
    let bag = DisposeBag()
    var searchBarText: String = ""

    let searchButtonClicked = PublishSubject<String>()
    
    let photos: BehaviorRelay<[Photo]> = BehaviorRelay(value: [])
    let isRequesting: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private var currentPage = 1
    private var hasNextPage = false
    
    init() {
        bindData()
    }
    
    private func bindData() {
        searchButtonClicked
            .filter({ !$0.isEmpty })
            .subscribe(onNext: { [weak self] keyword in
                self?.searchBarText = keyword
                self?.search(keyword: keyword, page: 1)
            })
            .disposed(by: bag)
    }

    
    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row >= (photos.value.count - 1) && !isRequesting.value && hasNextPage {
            search(keyword: searchBarText, page: currentPage + 1)
        }
    }
    
    private func search(keyword: String, page: Int) {
        // Only 1 request at once
        guard !isRequesting.value else { return }
        
        isRequesting.accept(true)
        
        ApiConnector.searchPhotos(keyword: keyword, page: page)
            .subscribe(
                onNext: { [weak self] searchResult in
                    guard let self = self else { return }
                    
                    if page == 1 {
                        self.photos.accept(searchResult.photos)
                    } else {
                        self.photos.accept(self.photos.value + searchResult.photos)
                    }
                    
                    self.isRequesting.accept(false)
                    self.currentPage = page
                    self.hasNextPage = searchResult.nextPage != nil
                },
                onError: { [weak self] error in
                    self?.isRequesting.accept(false)
                }
            )
            .disposed(by: bag)
    }
}


