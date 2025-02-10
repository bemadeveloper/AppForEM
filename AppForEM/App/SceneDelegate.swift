//
//  SceneDelegate.swift
//  AppForEM
//
//  Created by Bema on 5/2/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
       
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground() 
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
       
        
        window = UIWindow(windowScene: windowScene)
        //let viewController = ViewController(presenter: TodoListPresenterInput)
        
        let todoListModule = TodoListRouter.createModule()
        
        let navigationController = UINavigationController(rootViewController: todoListModule)
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

