//
//  PhotosTransformer.swift
//  LowkeyTest
//
//  Created by Yuan Cao on 2024/04/09.
//

import Foundation


// All the business logic is in here transformer, and you can add unit tests to this class with input and output

class PhotosTransformer {

    func transferProductsToViewModels(photos: CuratedPhotos) -> [PhotoCellViewModel] {
        photos.photos.map { photo in
            PhotoCellViewModel(
                title: "Author: " + photo.photographer,
                smallImageURL: URL(string: photo.src.small),
                imageURL: photo.src.large)
        }
    }

    func transferNextPage(photos: CuratedPhotos) -> String? {
        photos.nextPage
    }
}
