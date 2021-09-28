//
//  TrackModel.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 21.09.2021.
//

import Foundation


struct SearchResponse: Decodable {
    var resultCount: Int?
    var results: [Track]?
}

struct Track: Decodable {
    var trackName: String?
    var collectionName: String?
    var artistName: String?
    var artworkUrl100: String?
    var previewUrl: String?
}
