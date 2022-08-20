//
//  FavouriteViewPresenter.swift
//  White&Fluffy
//
//  Created by Lev on 24.07.2022.
//

import UIKit

class FavouriteViewPresenter: NSObject, UITableViewDataSource{
    
    let items = RealmService.shared.getData(FavouriteBase.self)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouritePhotosCell.identifier, for: indexPath) as! FavouritePhotosCell
        cell.setUp(items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        
        RealmService.shared.deleteData(items[indexPath.row])
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
