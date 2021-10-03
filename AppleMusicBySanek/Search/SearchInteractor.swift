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
        
        JSONEncoder().encodeInBackground(from: object) { data in
            print("Data \(String(data: data ?? Data(), encoding: .utf8))")
            if let trackName = object.trackName {
                userDefaults.set(data, forKey: trackName)
            }
        }
    }
}
