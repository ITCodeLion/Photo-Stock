//
//  MainViewPresenter.swift
//  White&Fluffy
//
//  Created by Lev on 24.07.2022.
//

import UIKit

class MainViewPresenter: NSObject {
    
//    var notifi: Void = NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    
    @objc func showOfflineDeviceUI(notification: NSNotification) {
            if NetworkMonitor.shared.isConnected {
                print("Connected")
                //randomFoto(completion: completion)
            } else {
                print("Not connected")
            }
        }
    
    var photos = [UnsplashPhoto]()
    private var networkDataRandom = NetworkServiceRandom()
    
    var networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    
    func randomFoto(completion: @escaping (()->())) {
        
        //NetworkMonitor.shared.startMonitoring()
        
       // while !NetworkMonitor.shared.isConnected {
            
        //}
        self.networkDataRandom.fetchImages { searchRandom in
            
            guard let fetchedPhotos = searchRandom else { return }
            self.photos = fetchedPhotos
            completion()
        }
        
        //NetworkMonitor.shared.stopMonitoring()
        

    }
    
    func searchBar(searchText: String, completion: @escaping (()->())) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                
                guard let fetchedPhotos = searchResults else { return }
                if searchText != "" {
                    self?.photos = fetchedPhotos.results
                    completion()
                }
            }
        })
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.identifier, for: indexPath) as! PhotosCell
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        return cell
    }
    
}
