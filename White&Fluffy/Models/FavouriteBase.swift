//
//  FavouriteBase.swift
//  White&Fluffy
//
//  Created by Lev on 27.06.2022.
//

import UIKit
import RealmSwift

protocol ModelProtocol {
    
}

class FavouriteBase: Object, ModelProtocol {
    
    @objc dynamic var urlSmall = ""
    @objc dynamic var urlRegular = ""
    @objc dynamic var like = false
    
    @objc dynamic var createdAt = ""
    @objc dynamic var descriptionPhoto = ""
    
    dynamic var downloads = RealmProperty<Int?>()
    @objc dynamic var user = ""
    @objc dynamic var location = ""
    
}
