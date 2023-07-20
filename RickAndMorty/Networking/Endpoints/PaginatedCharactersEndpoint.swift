//
//  PaginatedCharactersEndpoint.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 17/07/2023.
//

import Foundation

struct PaginatedCharactersEndpoint: Endpoint {
    let method: HTTPMethod = .GET
    let path: String = "character"
    let parameters: [String : String]
    
    init(page: Int, searchQuery: String) {
        var params = ["page": "\(page)"]
        if !searchQuery.isEmpty {
            params["name"] = searchQuery
        }
        
        parameters = params
    }
}
