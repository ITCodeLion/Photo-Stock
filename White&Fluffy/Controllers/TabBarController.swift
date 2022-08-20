//
//  TabBarController.swift
//  White&Fluffy
//
//  Created by Lev on 17.06.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    private enum TabBarItem {
        
        case foto
        case favourite
        
        var title: String {
            switch self {
            case .foto:
                return "Photos"
            case .favourite:
                return "Favourite"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .foto:
                return UIImage(systemName: "square.stack.3d.down.forward.fill")
            case .favourite:
                return UIImage(systemName: "heart.circle.fill")
            }
        }
    }
    
    private func setupTabBar() {
        
        let items: [TabBarItem] = [ .foto, .favourite ]
        self.viewControllers = items.map({ tabBarItem in
            switch tabBarItem {
            case .foto:
                
                let presenter = MainViewPresenter()
                return UINavigationController(rootViewController: MainViewController(with: presenter))
            case .favourite:
                
                let presenter = FavouriteViewPresenter()
                return UINavigationController(rootViewController: FavouriteViewController(with: presenter))
            }
        })
        self.viewControllers?.enumerated().forEach({ (index, vc) in
            vc.tabBarItem.title = items[index].title
            vc.tabBarItem.image = items[index].image
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.unselectedItemTintColor = .systemGray2
        self.tabBar.tintColor = .systemYellow
        self.setupTabBar()
        tabBar.backgroundColor = .black
        
        tabBar.isTranslucent = false
        
        let tabBarApperance = UITabBarAppearance()
        tabBarApperance.configureWithOpaqueBackground()
        tabBarApperance.backgroundColor = UIColor.black
        UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
        UITabBar.appearance().standardAppearance = tabBarApperance
    }
}
