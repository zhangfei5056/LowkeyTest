//
//  PhotosListDataManager.swift
//  LowkeyTest
//
//  Created by Yuan Cao on 2023/11/1.
//

import UIKit

class PhotosListDataManager {

    let productTransformer: PhotosTransformer
    var data: [CellViewModelProtocol] = []
    var reloadPage: (() -> Void)?
    private var nextPage: String?

    let httpService: HTTPServiceProtocol

    init(httpService: HTTPServiceProtocol = HTTPService(), productTransformer:PhotosTransformer = PhotosTransformer()) {
        self.httpService = httpService
        self.productTransformer = productTransformer
    }
    

    @MainActor
    func fetchData() {
        Task {
            if let photos = try? await httpService.getRequestAsync(url: NetworkConstant.url) {
                self.data = self.productTransformer.transferProductsToViewModels(photos: photos)
                self.nextPage = self.productTransformer.transferNextPage(photos: photos)
                self.reloadPage?()
            }
        }
    }

    var isLoading: Bool = false

    @MainActor
    func loadMore() {
        if !isLoading {
            isLoading = true
            Task {
                if let url = self.nextPage, let products = try? await httpService.getRequestAsync(url: url) {
                    data += productTransformer.transferProductsToViewModels(photos: products)
                    reloadPage?()
                    isLoading = false
                }
            }
        }
    }
}
