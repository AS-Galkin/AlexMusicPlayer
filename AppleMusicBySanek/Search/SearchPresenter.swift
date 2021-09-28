//
//  SearchPresenter.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 22.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SDWebImage

protocol SearchPresentationLogic {
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?
  
  func presentData(response: Search.Model.Response.ResponseType) {
    switch response {
    case .presentTracks(let searchedTracks):
        
        guard let cells = searchedTracks?.results?.map({ track -> SearchViewModel.Cell in
            return SearchViewModel.Cell.init(trackName: track.trackName,
                                           collectionName: track.collectionName,
                                           artistName: track.artistName,
                                           trackImageUrl: track.artworkUrl100,
                                           trackPreviewUrl: track.previewUrl)
        }) else { return }
        
        let cellViewModel = SearchViewModel.init(cells: cells)
        
        viewController?.displayData(viewModel: .displayTracks(displayTerm: cellViewModel))
        break
    case .presentSearchTableFooterView:
        viewController?.displayData(viewModel: .displayFooterView)
        break
    case .removeSearchTableFooterView:
        viewController?.displayData(viewModel: .hideFooterView)
        break
    }
  }
}
