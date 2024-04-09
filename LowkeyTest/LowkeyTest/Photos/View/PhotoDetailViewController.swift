//
//  PhotoDetailViewController.swift
//  ProductList_UIKit
//
//  Created by Yuan Cao on 2024/4/10.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    lazy var productImageView: CachedImageView = {
        let productImageView = CachedImageView(frame: .zero)
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        return productImageView
    }()

    let imageURL: String

    init(imageURL: String) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productImageView.topAnchor.constraint(equalTo: view.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        productImageView.loadImage(url: URL(string: imageURL))
    }
}
