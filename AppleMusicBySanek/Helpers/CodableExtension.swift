//
//  CodableExtension.swift
//  MusicPlayer
//
//  Created by Александр Галкин on 03.10.2021.
//

import Foundation

extension JSONDecoder {
    func decodeInBackground<T: Decodable>(from data: Data, onDecode: @escaping (T?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let decoded: T? = try? self.decode(T.self, from: data)
            
            DispatchQueue.main.async {
                onDecode(decoded)
            }
        }
    }
}

extension JSONEncoder {
    func encodeInBackground<T: Encodable>(from object: T?, onEncode: @escaping (Data?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let result = try? self.encode(object)
            
            DispatchQueue.main.async {
                onEncode(result)
            }
        }
    }
}
