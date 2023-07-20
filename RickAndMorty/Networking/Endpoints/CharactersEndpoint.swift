//
//  CharactersEndpoint.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 19/07/2023.
//

import Foundation

struct CharactersEndpoint: Endpoint {
    let method: HTTPMethod = .GET
    let path: String
    let parameters: [String : String] = [:]
    
    init(ids: [Int]) {
        let commaSeparatedIds = ids.map { String($0) }.joined(separator: ",")
        path = "character/" + "[\(commaSeparatedIds)]"
    }
}
