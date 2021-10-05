//
//  SearchViewController.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 22.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
    
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    private var cellViewModel: SearchViewModel = SearchViewModel(cells: []) {
        didSet {
            self.searchTableView.reloadData()
        }
    }
    private var timer: Timer?
    private lazy var searchTableFooterView: SearchTableFooterView = SearchTableFooterView()
    var tabBarDelegate: MainTabBarDelegate?
    
    @IBOutlet weak var searchTableView: UITableView!
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SearchInteractor()
        let presenter             = SearchPresenter()
        let router                = SearchRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupSearchBar()
        setupTableView()
    }
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayTracks(let cellViewModel):
            self.cellViewModel = cellViewModel
            break
        case .displayFooterView:
            searchTableView.footerView(forSection: 0)?.textLabel?.text = ""
            searchTableFooterView.showActivity()
            break
        case .hideFooterView:
            searchTableFooterView.hideActivity()
            break
        }
    }
    
    private func setupSearchBar() {
        let search = UISearchController()
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "TrackCell", bundle: nil)

        searchTableView.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        searchTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "FooterCell")
        
        searchTableView.tableFooterView = searchTableFooterView
    }
    
    //MARK: - IBActions
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as? TrackCell else {
            return UITableViewCell()
        }
        
        if let mainTabBar = tabBarController as? MainTabBarController {
            mainTabBar.detailTrackView.delegate = self
        }
        
        let cellData = cellViewModel.cells[indexPath.row]
        cell.setViewData(viewModel: cellData)
        cell.interactorDelegate = interactor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter some term in search..."
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellViewModel.cells.count > 0 ? 0 : 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tabBarDelegate?.maximazeDetailTrackView(viewModel: cellViewModel.cells[indexPath.row])
        
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self]_ in
            self?.interactor?.makeRequest(request: .getTracks(searchTerm: searchText))
            searchBar.endEditing(true)
        })
        
    }
}

extension SearchViewController: TrackMovingDelegate {
    
    //MARK: - Section for getting next or prev track data
    private func getIndexPath(seek: Int, indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: indexPath.row + seek, section: indexPath.section)
    }
    
    func move(seek: Int) -> SearchViewModel.Cell? {
        guard let curentIndexPath = searchTableView.indexPathForSelectedRow else {
            return nil
        }
        
        var nextIndexPath = IndexPath(item: 0, section: 0)

        if curentIndexPath.row == cellViewModel.cells.count - 1 && seek > 0 {
            nextIndexPath.row = 0
            nextIndexPath.section = curentIndexPath.section
        } else if curentIndexPath.row == 0 && seek < 0 {
            nextIndexPath.row = cellViewModel.cells.count - 1
            nextIndexPath.section = curentIndexPath.section
        } else {
            nextIndexPath = getIndexPath(seek: seek, indexPath: curentIndexPath)
        }
        
        let viewModel = cellViewModel.cells[nextIndexPath.row]
        searchTableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        
        return viewModel
    }
}
