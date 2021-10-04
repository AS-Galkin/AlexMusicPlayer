//
//  SearchInteractor.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 22.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    static let userDefaultsKey = "tracks"
    private let networkService = NetworkLayer()
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }
        
        switch request {
        case .getTracks(let searchText):
            self.presenter?.presentData(response: .presentSearchTableFooterView)
            networkService.fetchResults(searchText: searchText) { [weak self] response in
                self?.presenter?.presentData(response: .presentTracks(responseTerm: response))
                self?.presenter?.presentData(response: .removeSearchTableFooterView)
            }
            break
        }
    }
}

extension SearchInteractor: SaveDataProtocol {
    func saveTrack(for object: SearchViewModel.Cell) {
        let userDefaults = UserDefaults.standard
        
        var existing: [SearchViewModel.Cell]? = []
        
        if let data = userDefaults.data(forKey: SearchInteractor.userDefaultsKey) {
            JSONDecoder().decodeInBackground(from: data) { (tracks: [SearchViewModel.Cell]?) in
                existing = tracks
                if !existing!.contains(where: { cell in
                    guard let trackName = object.trackName else { return true }
                    return trackName == cell.trackName
                }) {
                    existing?.append(object)
                    JSONEncoder().encodeInBackground(from: existing) { data in
                        userDefaults.set(data, forKey: SearchInteractor.userDefaultsKey)
                    }
                }
            }
        } else {
            existing?.append(object)
            JSONEncoder().encodeInBackground(from: existing) { data in
                userDefaults.set(data, forKey: SearchInteractor.userDefaultsKey)
            }
        }
    }
    
    static func loadTracks(closure: @escaping ([SearchViewModel.Cell]?) -> Void) {
        if let data = UserDefaults.standard.data(forKey: SearchInteractor.userDefaultsKey) {
            JSONDecoder().decodeInBackground(from: data) { (tracks: [SearchViewModel.Cell]?) in
                closure(tracks)
            }
        }
    }
}

