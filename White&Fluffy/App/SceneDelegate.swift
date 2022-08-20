//
//  SceneDelegate.swift
//  White&Fluffy
//
//  Created by Lev on 17.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        let tabBarVC = TabBarController()
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        
    }
}

