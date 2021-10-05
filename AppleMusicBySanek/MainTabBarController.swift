//
//  MainTabBarController.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 17.09.2021.
//

import UIKit
import SwiftUI

protocol MainTabBarDelegate: AnyObject {
    func minimizeDetailTrackView()
    func maximazeDetailTrackView(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    var detailTrackView: TrackDetailView = TrackDetailView.loadFromNib()
    private var maximalTrackViewTopAnchor: NSLayoutConstraint!
    private var minimalTrackViewTopAnchor: NSLayoutConstraint!
    private var minimalTrackViewBottomAnchor: NSLayoutConstraint!
    private var maximalTrackViewBottomAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        detailTrackView.tabBarDelegate = self
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        detailTrackView.delegate = searchVC
        searchVC.tabBarDelegate = self
        view.insertSubview(detailTrackView, belowSubview: tabBar)

        let cells: [SearchViewModel.Cell]? = try? JSONDecoder().decode([SearchViewModel.Cell].self, from: UserDefaults.standard.data(forKey: SearchInteractor.userDefaultsKey) ?? Data()) as? [SearchViewModel.Cell]
                
        var libraryView = Library(tracks: cells ?? [SearchViewModel.Cell()])
        libraryView.tabBarDelegate = self
        let hosterVC = UIHostingController(rootView: libraryView)
        hosterVC.tabBarItem.image = #imageLiteral(resourceName: "library")
        hosterVC.tabBarItem.title = "Library"
        
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        viewControllers = [
            hosterVC,
            generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "search"), title: "Search")
        ]
        
        detailTrackView.translatesAutoresizingMaskIntoConstraints = false
        
        maximalTrackViewTopAnchor = detailTrackView.topAnchor.constraint(equalTo: view.topAnchor)
        minimalTrackViewTopAnchor = detailTrackView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        minimalTrackViewBottomAnchor = detailTrackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        maximalTrackViewBottomAnchor = detailTrackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        firstPositionDetailTrack()
    }
    
    private func firstPositionDetailTrack() {
        detailTrackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailTrackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        minimalTrackViewTopAnchor.constant = 64
        minimalTrackViewTopAnchor.isActive = true
        maximalTrackViewBottomAnchor.isActive = true
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

extension MainTabBarController: MainTabBarDelegate {
    func minimizeDetailTrackView() {
        minimalTrackViewBottomAnchor.isActive = false
        maximalTrackViewBottomAnchor.isActive = true
        maximalTrackViewTopAnchor.isActive = false
        minimalTrackViewTopAnchor.constant = -64
        minimalTrackViewTopAnchor.isActive = true

        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.tabBar.alpha = 1.0
            self?.detailTrackView.trackStackView.alpha = 0.0
            self?.detailTrackView.miniTrackView.alpha = 1.0
        } completion: { _ in
            
        }
    }
    
    func maximazeDetailTrackView(viewModel: SearchViewModel.Cell?) {
        minimalTrackViewTopAnchor.isActive = false
        minimalTrackViewTopAnchor.constant = 0
        maximalTrackViewTopAnchor.isActive = true
        
        maximalTrackViewBottomAnchor.isActive = false
        minimalTrackViewBottomAnchor.isActive = true
        
        if let viewModel = viewModel {
            detailTrackView.setDisplayedData(viewModel: viewModel)
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.tabBar.alpha = 0.0
            self?.detailTrackView.miniTrackView.alpha = 0.0
            self?.detailTrackView.trackStackView.alpha = 1.0
        } completion: { _ in }
        
        
    }
}
