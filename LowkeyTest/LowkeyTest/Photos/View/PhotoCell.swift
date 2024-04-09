//
//  PhotoCell.swift
//  LowkeyTest
//
//  Created by Yuan Cao on 2024/04/09.
//

import UIKit

protocol CellProtocol {
    static var reuseId: String { get }
    func setup(viewModel: CellViewModelProtocol)
}

class PhotoCell: UITableViewCell {

    static let margin: CGFloat = 12
    static let profileSize: CGFloat = 80
    static let containerViewRadius: CGFloat = 12
    static let profileImageRadius: CGFloat = 8

    lazy var containerView: UIView = {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = Self.containerViewRadius
        setupShadow(containerView)
        return containerView
    }()

    lazy var profileImageView: CachedImageView = {
        let profileImageView = CachedImageView(frame: .zero)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = Self.profileImageRadius
        return profileImageView
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.numberOfLines = 2
        return titleLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(profileImageView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.margin),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.margin),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.margin/2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Self.margin/2)
        ])
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: Self.profileSize),
            profileImageView.heightAnchor.constraint(equalToConstant: Self.profileSize),
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Self.margin),
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Self.margin),
            profileImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Self.margin)
        ])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: Self.margin),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Self.margin),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Self.margin)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        titleLabel.text = nil
    }

    private func setupShadow(_ containerView: UIView) {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        containerView.layer.shadowRadius = 5
    }

}

extension PhotoCell: CellProtocol {

    static var reuseId: String = String(describing: PhotoCell.self)

    func setup(viewModel: CellViewModelProtocol) {
        guard let viewModel = viewModel as? PhotoCellViewModel else {
            return
        }
        titleLabel.text = viewModel.title
        profileImageView.loadImage(url: viewModel.smallImageURL)
    }
}
