//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 17/07/2023.
//

import Foundation

protocol Endpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String] { get }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    
    var name: String {
        self.rawValue
    }
}

struct RequestFactory {
    private static let baseUrl = "https://rickandmortyapi.com/api"
    
    static func urlRequest(fromEndpoint endpoint: Endpoint) -> URLRequest {
        guard var url = URL(string: baseUrl)?.appendingPathComponent(endpoint.path) else {
            fatalError("Invalid base url!")
        }

        if !endpoint.parameters.isEmpty {
            url.append(queryItems: endpoint.parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.name
        return request
    }
}
