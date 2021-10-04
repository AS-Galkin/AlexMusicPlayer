//
//  SearchModels.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 22.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getTracks(searchTerm: String)
      }
    }
    struct Response {
      enum ResponseType {
        case presentTracks(responseTerm: SearchResponse?)
        case presentSearchTableFooterView
        case removeSearchTableFooterView
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayTracks(displayTerm: SearchViewModel)
        case displayFooterView
        case hideFooterView
      }
    }
  }
}

struct SearchViewModel: Codable {
    struct Cell: CellViewModelProtocol, Codable, Identifiable {
        var id = UUID()
        var trackName: String?
        var collectionName: String?
        var artistName: String?
        var trackImageUrl: String?
        var trackPreviewUrl: String?
    }
    
    var cells: [Cell]
}
