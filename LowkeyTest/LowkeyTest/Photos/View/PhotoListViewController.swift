//
//  ProductListViewController.swift
//  LowkeyTest
//
//  Created by Yuan Cao on 2024/04/09.
//

import UIKit

class PhotoListViewController: UIViewController {

    lazy var dataManager: PhotosListDataManager = {
        let dataManager = PhotosListDataManager()
        dataManager.reloadPage = {
            self.tableView.reloadData()
        }
        return dataManager
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.reuseId)
        return tableView
    }()

    lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .red
        refresh.attributedTitle = NSAttributedString(string: "Pull Refresh")
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresh
    }()

    @objc func refreshData() {
        refresh.beginRefreshing()
        dataManager.fetchData()
        refresh.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.addSubview(refresh)
        dataManager.fetchData()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension PhotoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = dataManager.data[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reuseId, for: indexPath) as? CellProtocol else {
            return UITableViewCell()
        }
        cell.setup(viewModel: viewModel)
        if let cell = cell as? UITableViewCell {
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

extension PhotoListViewController: UITableViewDelegate {
    
    // Pull up to load more

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            dataManager.loadMore()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = self.dataManager.data[indexPath.row] as? PhotoCellViewModel else {
            return
        }
        let photoDetailViewController = PhotoDetailViewController(imageURL: viewModel.imageURL)
        self.navigationController?.pushViewController(photoDetailViewController, animated: true)
    }
}
