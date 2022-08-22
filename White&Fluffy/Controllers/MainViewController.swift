//
//  MainViewController.swift
//  White&Fluffy
//
//  Created by Lev on 17.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    let presenter: MainViewPresenter!
    
    init(with presenter: MainViewPresenter){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var networkDataFetcher = NetworkDataFetcher()
    
    private var timer: Timer?
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .systemYellow
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.tabBarController?.tabBar.isTranslucent = false
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = .white
    }
    
    private lazy var photoCollection: UICollectionView = {
        let photoLayout = UICollectionViewFlowLayout()
        photoLayout.scrollDirection = .vertical
        let photoCollection = UICollectionView(frame: .zero, collectionViewLayout: photoLayout)
        photoCollection.dataSource = presenter
        photoCollection.delegate = self
        photoCollection.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.identifier)
        photoCollection.translatesAutoresizingMaskIntoConstraints = false
        photoCollection.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        photoCollection.contentInsetAdjustmentBehavior = .automatic
        photoCollection.backgroundColor = .clear
        return photoCollection
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.color = .systemYellow
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private func layout() {
        
        view.backgroundColor = .clear
        view.addSubview(photoCollection)
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: photoCollection.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: photoCollection.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photoCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photoCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupSearchBar()
        
        presenter.randomFoto{ [weak self] in
            self?.photoCollection.reloadData()
            self?.spinner.stopAnimating()
        }
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow]
        let attributedTitle = NSAttributedString(string: "Pull to refresh random photo", attributes: attributes)

        refreshControl.attributedTitle = attributedTitle

        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        photoCollection.addSubview(refreshControl)

        layout()
    }
    
    @objc func refresh(_ sender: AnyObject) {

        self.spinner.startAnimating()
        presenter.randomFoto{ [weak self] in
            self?.photoCollection.reloadData()
            self?.spinner.stopAnimating()
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.spinner.startAnimating()
        presenter.searchBar(searchText: searchText) { [weak self] in
            self?.photoCollection.reloadData()
        }
        self.spinner.stopAnimating()
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let presenter = DetailViewPresenter(model: self.presenter.photos[indexPath.item])
        presenter.prepareModel()
        let detailVC = DetailViewController(with: presenter)
        presenter.viewController = detailVC
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension  MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = presenter.photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
