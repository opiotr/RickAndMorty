//
//  PaginatedData.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 18/07/2023.
//

import Foundation

struct PaginatedData<T> {
    let info: PageInfo
    let items: [T]
}

struct PageInfo {
    let count: Int
    let pages: Int
    let nextPage: Int?
}
