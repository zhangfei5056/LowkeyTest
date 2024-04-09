//
//  PhotoCellViewModel.swift
//  LowkeyTest
//
//  Created by Yuan Cao on 2024/04/09.
//

import Foundation

protocol CellViewModelProtocol {
    var reuseId: String { get }
}

struct PhotoCellViewModel: CellViewModelProtocol {
    var reuseId: String {
        return PhotoCell.reuseId
    }

    let title: String
    let smallImageURL: URL?
    let imageURL: String
}

