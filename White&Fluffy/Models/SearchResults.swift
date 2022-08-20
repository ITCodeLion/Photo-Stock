//
//  SearchResults.swift
//  White&Fluffy
//
//  Created by Lev on 19.06.2022.
//

import UIKit
import RealmSwift
import SwiftUI

struct SearchResults: Decodable {
    
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable, Equatable, ModelProtocol {
    
    let created_at: String?
    
    let width: Int
    let height: Int
    let urls: [URLKind.RawValue:String]
    
    
    let description: String?
    //let user: [userInfo.RawValue: Any]
    let downloads: Int?
    let user: UserInfo
    //let location: String?
    
    //    enum userInfo: Any {
    //        case username
    //        case name
    //        //case first_name
    //        //case last_name
    //    }
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct UserInfo: Decodable, Equatable {
    let id: String?
    let username: String?
    let name: String?
    let location: String?
}
