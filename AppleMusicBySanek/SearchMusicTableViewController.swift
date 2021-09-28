//
//  SearchViewController.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 17.09.2021.
//

import Foundation
import UIKit
import Alamofire

class SearchMusicTableViewController: UITableViewController {
    
    private let networkLayer = NetworkLayer()
    private var timer: Timer?
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var tracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.delegate = self
    }
}

extension SearchMusicTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        let track = tracks[indexPath.row]

        if let trackName = track.trackName,
           let artistName = track.artistName {
            cell.textLabel?.text = trackName + "\n" + artistName
        }
        
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "search")
        
        return cell
    }
}

extension SearchMusicTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self]_ in
            self?.networkLayer.fetchResults(searchText: searchText) { [weak self] response in
                guard let results = response?.results else {
                    self?.tracks = []
                    return
                }
                
                self?.tracks = results
                self?.tableView.reloadData()
                self?.dismiss(animated: true, completion: nil)
            }
        })
    }
}
