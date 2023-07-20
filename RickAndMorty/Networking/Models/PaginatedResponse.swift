//
//  PaginatedResponse.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 17/07/2023.
//

import Foundation

struct PaginatedResponse<T: Decodable>: Decodable {
    let info: PaginationInfoResponse
    let results: [T]
}

struct PaginationInfoResponse: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
