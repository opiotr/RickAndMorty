//
//  CharactersRepository.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 18/07/2023.
//

import Foundation

protocol CharactersRepositoryProtocol {
    func fetchCharacters(page: Int, searchQuery: String) async throws -> PaginatedData<Character>
    func fetchCharacters(withIds ids: [Int]) async throws -> [Character]
}

final class CharactersRepository: CharactersRepositoryProtocol {
    private let requestService: RequestServiceProtocol
    
    init(requestService: RequestServiceProtocol = RequestService()) {
        self.requestService = requestService
    }
    
    func fetchCharacters(page: Int, searchQuery: String) async throws -> PaginatedData<Character> {
        let endpoint = PaginatedCharactersEndpoint(page: page, searchQuery: searchQuery)
        let request = RequestFactory.urlRequest(fromEndpoint: endpoint)
        let data: PaginatedResponse<CharacterResponse> = try await requestService.run(request: request)

        return PaginatedData(
            info: PageInfo(
                count: data.info.count,
                pages: data.info.pages,
                nextPage: data.info.next != nil ? page + 1 : nil
            ),
            items: data.results.map { Character(from: $0) }
        )
    }
    
    func fetchCharacters(withIds ids: [Int]) async throws -> [Character] {
        let endpoint = CharactersEndpoint(ids: ids)
        let request = RequestFactory.urlRequest(fromEndpoint: endpoint)
        let data: [CharacterResponse] = try await requestService.run(request: request)
        
        return data.map { Character(from: $0) }
    }
}

