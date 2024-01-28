//
//  PexelsApiSearchTests.swift
//  PexelsApiSearchTests
//
//  Created by Chun Chieh Chang on 2024/01/26.
//

import XCTest
import RxSwift
@testable import PexelsApiSearch

final class PexelsApiSearchTests: XCTestCase {
    let bag = DisposeBag()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchPhotos() throws {
        ApiConnector.searchPhotos(keyword: "Cat", page: 1).subscribe(onNext: { searchResult in
            XCTAssertTrue(searchResult.photos.count > 0)
        }).disposed(by: bag)
    }
}
