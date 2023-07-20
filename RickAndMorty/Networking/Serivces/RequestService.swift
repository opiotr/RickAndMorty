//
//  RequestService.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 17/07/2023.
//

import Foundation

protocol RequestServiceProtocol {
    func run<T: Decodable>(request: URLRequest) async throws -> T
}

final class RequestService: RequestServiceProtocol {
    private let decoder: JSONDecoder
    private let urlSession: URLSession
    
    init(decoder: JSONDecoder = .init(), urlSession: URLSession = .shared) {
        self.decoder = decoder
        self.urlSession = urlSession
    }

    func run<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await urlSession.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw ApiError.malformedData
        }
        guard response.statusCode >= 200 && response.statusCode <= 299 else {
            throw ApiError.requestError(reason: errorReason(byStatusCode: response.statusCode))
        }
        
        do {
            let responseData = try decoder.decode(T.self, from: data)
            return responseData
        } catch {
            print(String(describing: error))
            throw ApiError.dataDecodingError(reason: error.localizedDescription)
        }
    }
    
    private func errorReason(byStatusCode code: Int) -> String {
        switch code {
        case 400:
            return "Bad request"
        case 401:
            return "Unauthorized"
        case 403:
            return "Forbidden"
        case 404:
            return "Not found"
        default:
            // Handle other codes if needed. For now it's enough.
            return "unknown"
        }
    }
}

enum ApiError: Error {
    case malformedData
    case requestError(reason: String)
    case dataDecodingError(reason: String)
}
