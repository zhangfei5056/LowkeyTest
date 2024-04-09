//
//  PhotosTransformerTests.swift
//  LowkeyTestTests
//
//  Created by Yuan Cao on 2024/4/10.
//

import XCTest
@testable import LowkeyTest

class PhotosTransformerTests: XCTestCase {

    var sut: PhotosTransformer!

    override func setUp() {
        super.setUp()
        sut = PhotosTransformer()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Test transferProductsToViewModels

    func testTransferProductsToViewModels() {
        // Given
        let photo1 = Photo(id: 1, width: 100, height: 100, url: "url1", photographer: "Photographer1", photographerURL: "photographerUrl1", photographerID: 1, avgColor: "avgColor1", src: Src(original: "original1", large2X: "large2X1", large: "large1", medium: "medium1", small: "small1", portrait: "portrait1", landscape: "landscape1", tiny: "tiny1"), liked: true, alt: "alt1")
        let photo2 = Photo(id: 2, width: 200, height: 200, url: "url2", photographer: "Photographer2", photographerURL: "photographerUrl2", photographerID: 2, avgColor: "avgColor2", src: Src(original: "original2", large2X: "large2X2", large: "large2", medium: "medium2", small: "small2", portrait: "portrait2", landscape: "landscape2", tiny: "tiny2"), liked: false, alt: "alt2")
        let curatedPhotos = CuratedPhotos(page: 1, perPage: 10, photos: [photo1, photo2], totalResults: 2, prevPage: nil, nextPage: "nextPage")

        // When
        let viewModels = sut.transferProductsToViewModels(photos: curatedPhotos)

        // Then
        XCTAssertEqual(viewModels.count, 2)
        XCTAssertEqual(viewModels[0].title, "Author: Photographer1")
        XCTAssertEqual(viewModels[1].title, "Author: Photographer2")
        XCTAssertEqual(viewModels[0].smallImageURL, URL(string: "small1"))
        XCTAssertEqual(viewModels[1].smallImageURL, URL(string: "small2"))
        XCTAssertEqual(viewModels[0].imageURL, "large1")
        XCTAssertEqual(viewModels[1].imageURL, "large2")
    }

    // MARK: - Test transferNextPage

    func testTransferNextPage() {
        // Given
        let curatedPhotos = CuratedPhotos(page: 1, perPage: 10, photos: [], totalResults: 0, prevPage: nil, nextPage: "nextPage")

        // When
        let nextPage = sut.transferNextPage(photos: curatedPhotos)

        // Then
        XCTAssertEqual(nextPage, "nextPage")
    }
}
