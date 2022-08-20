//
//  RealmService.swift
//  White&Fluffy
//
//  Created by Lev on 29.06.2022.
//

import UIKit
import RealmSwift

final class RealmService {
    
    private init() {}
    
    static let shared = RealmService()
    
    lazy var realm: Realm = {
        let realm = try! Realm()
        
        return realm
    }()
    // MARK: - Public methods
    
    public func getData<T: Object>(_ item: T.Type) -> Results<T> {
        return realm.objects(item)
    }
    
    public func addData<T: Object>(_ item: T) {
        try? realm.write {
            realm.add(item)
        }
    }
    
    public func deleteAllData() {
        try? realm.write {
            realm.deleteAll()
        }
    }
    
    public func deleteData<T: Object>(_ item: T) {
        try? realm.write {
            realm.delete(item)
        }
    }
    
    public func changeLike (item: FavouriteBase){
        try? realm.write {
            item.like.toggle()
        }
    }
}
