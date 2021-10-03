//
//  NetworkLayer.swift
//  AppleMusicBySanek
//
//  Created by Александр Галкин on 21.09.2021.
//

import Foundation
import Alamofire

class NetworkLayer {
    public func fetchResults(searchText: String, completion: @escaping (_ results: SearchResponse?) -> Void) {
        let searchURL = "https://itunes.apple.com/search"
        let parametes = ["term":"\(searchText)", "limit":"100"]
        AF.request(searchURL, method: .get, parameters: parametes).response { dataResponse in
            
            if let error = dataResponse.error {
                print("error was received from request: \(error.localizedDescription)")
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            let model = try? JSONDecoder().decode(SearchResponse.self, from: data) as SearchResponse
            
            if model != nil {
                completion(model)
            }
        }
    }
}
