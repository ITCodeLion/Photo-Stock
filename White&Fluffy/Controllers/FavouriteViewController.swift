//
//  FavouriteViewController.swift
//  White&Fluffy
//
//  Created by Lev on 19.06.2022.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    let presenter: FavouriteViewPresenter!
    
    init(with presenter: FavouriteViewPresenter){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "FAVOURITE"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .systemYellow
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.tabBarController?.tabBar.isTranslucent = false
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = presenter
        tableView.delegate = self
        tableView.backgroundColor = .systemGray5
        tableView.register(FavouritePhotosCell.self, forCellReuseIdentifier: FavouritePhotosCell.identifier)
        tableView.register(FavouritePhotosCell.self, forCellReuseIdentifier: FavouritePhotosCell.identifier)
        return tableView
    }()
    
    private func layout() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupNavigationBar()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension FavouriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let presenter = DetailViewPresenter(model: self.presenter.items[indexPath.row])
        
        presenter.prepareModel()
        let detailVC = DetailViewController(with: presenter)
        presenter.viewController = detailVC
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
