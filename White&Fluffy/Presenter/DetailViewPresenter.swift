//
//  DetailViewPresenter.swift
//  White&Fluffy
//
//  Created by Lev on 24.07.2022.
//

import UIKit
import RealmSwift

protocol DVPresenterProtocol {
    
    var model: ModelProtocol { get }
    
    var viewController: DetailViewController? { get }
    
    func prepareModel()
    func addPhoto()
    func deletePhoto()
}

class DetailViewPresenter: DVPresenterProtocol {
    
    weak var viewController: DetailViewController?
    
    var model: ModelProtocol
    
    init(model: ModelProtocol) {
        self.model = model
    }
    
    private var favouritePhoto: FavouriteBase?
    private var infoData: UnsplashPhoto?
    private let items = RealmService.shared.getData(FavouriteBase.self)
    
    var modelDetail: DetailModel?
    
    private var likePressed: Bool = false
    
    func deletePhoto(){
        
        guard let model = modelDetail  else { return }
        
        var indexRealm: Int = 0
        if items.count != 0 {
            items.enumerated().forEach { index, element in
                if element.urlRegular == model.regularUrl {
                    
                    indexRealm = index
                    
                    RealmService.shared.deleteData(items[indexRealm])
                }
            }
        }
        
        likePressed = false
        
        modelDetail?.likePressed = likePressed
        
        modelDetail?.likePressed = false
        
        viewController?.photoUpdated(model: modelDetail!)
    }
    
    func addPhoto(){
        
        guard let model = modelDetail else { return }
        
        let newPhoto = FavouriteBase()
        newPhoto.urlRegular = model.regularUrl
        newPhoto.urlSmall = model.smallUrl
        newPhoto.like = true
        newPhoto.downloads.value = Int(model.downloads) ?? nil
        
        newPhoto.createdAt = model.date
        newPhoto.user = model.author
        newPhoto.descriptionPhoto = model.description
        newPhoto.location = model.location
        
        RealmService.shared.addData(newPhoto)
        
        modelDetail?.likePressed = true
        
        viewController?.photoUpdated(model: modelDetail!)
    }
    
    func prepareModel() {
        switch model {
        case is FavouriteBase:
            guard let infoModel = model as? FavouriteBase else { return }
            favouritePhoto = infoModel
            guard let info = favouritePhoto else { return }
            
            let downloadFoto = info.downloads.value != nil ? String(info.downloads.value!) : "-"
            
            var indexRealm: Int? = nil
            
            if items.count != 0 {
                items.enumerated().forEach { index, element in
                    if element.urlRegular == info.urlRegular {
                        indexRealm = index
                        let items = RealmService.shared.getData(FavouriteBase.self)
                        likePressed = items[index].like
                    }
                }
            }
            
            modelDetail = DetailModel(author: info.user, description: info.descriptionPhoto, location: info.location, date: info.createdAt, downloads: downloadFoto, fotoUrl: info.urlRegular, likePressed: likePressed, indexRealmBase: indexRealm, regularUrl: info.urlRegular, smallUrl: info.urlSmall)
            
        case is UnsplashPhoto:
            guard let infoModel = model as? UnsplashPhoto else { return }
            infoData = infoModel
            guard let info = infoData, let imageUrl = info.urls["regular"], let smallUrl = info.urls["small"] else { return }
            
            let nickname = info.user.username ?? "-"
            let description =  info.description ?? "-"
            let place = info.user.location ?? "-"
            let createdAt = info.created_at ?? "-"
            let loaded = info.downloads != nil ? String(info.downloads!) : "-"
            var indexPhoto: Int? = nil
            
            if items.count != 0 {
                items.enumerated().forEach { index, element in
                    if element.urlRegular == imageUrl {
                        likePressed = true
                        indexPhoto = index
                    }
                }
            }
            
            modelDetail = DetailModel(author: nickname, description: description, location: place, date: createdAt, downloads: loaded, fotoUrl: imageUrl, likePressed: likePressed, indexRealmBase: indexPhoto, regularUrl: imageUrl, smallUrl: smallUrl)
            
        default:
            fatalError()
        }
    }
}

struct DetailModel {
    
    let author: String
    let description: String
    let location: String
    let date: String
    let downloads: String
    
    let fotoUrl: String
    
    var likePressed: Bool
    let indexRealmBase: Int?
    
    let regularUrl: String
    let smallUrl: String
}
