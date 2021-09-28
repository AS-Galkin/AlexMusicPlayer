//
//  MainTabBarController.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 17.09.2021.
//

import UIKit


class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()

        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        viewControllers = [
            generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "search"), title: "Search"),
            generateViewController(rootViewController: ViewController(), image: #imageLiteral(resourceName: "library"), title: "Library"),
        ]
    }
    
    private func generateViewController(rootViewController: UIViewController,image: UIImage, title: String) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        
        rootViewController.title = title
        
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
}
