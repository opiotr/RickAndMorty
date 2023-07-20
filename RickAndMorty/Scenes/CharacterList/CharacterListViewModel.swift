//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 17/07/2023.
//

import Foundation
import Combine

final class CharacterListViewModel: ObservableObject {
    enum State {
        case contentReady
        case loading
        case error
        case noSearchResults
    }

    @Published private(set) var items: [Character] = []
    @Published private(set) var state: State = .loading
    @Published var searchQuery = ""

    private var pageInfo: PageInfo?
    private var currentPage = Constants.initialPage
    private var isLoadingNextPage = false
    private var cancellables = Set<AnyCancellable>()
    
    private let repository: CharactersRepositoryProtocol
    
    init(repository: CharactersRepositoryProtocol = CharactersRepository()) {
        self.repository = repository
        
        bind()
    }

    func fetchInitialData(forced: Bool = false) async {
        guard state != .loading && items.isEmpty || forced else { return }

        currentPage = Constants.initialPage

        await MainActor.run {
            state = .loading
            items.removeAll()
        }
        await fetchData(page: currentPage)
    }
    
    func fetchMoreDataIfNeeded(after item: Character) async {
        guard !isLoadingNextPage else {
            return
        }
        guard let index = items.firstIndex(where: { $0.id == item.id }), index == items.count - 1 else {
            return
        }
        guard let nextPage = pageInfo?.nextPage else {
            return
        }

        isLoadingNextPage = true
        currentPage = nextPage

        await fetchData(page: currentPage)

        isLoadingNextPage = false
    }

    private func bind() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { query in
                Task { [weak self] in
                    await self?.fetchInitialData(forced: true)
                }
            }
            .store(in: &cancellables)
    }

    private func fetchData(page: Int) async {
        do {
            let data: PaginatedData<Character> = try await repository.fetchCharacters(
                page: currentPage,
                searchQuery: searchQuery
            )
            pageInfo = data.info
            await MainActor.run {
                items.append(contentsOf: data.items)
                state = .contentReady
            }
        } catch {
            if items.isEmpty {
                await MainActor.run {
                    state = searchQuery.isEmpty ? .error : .noSearchResults
                }
            }
        }
    }
}

private extension CharacterListViewModel {
    struct Constants {
        static let initialPage = 1
    }
}
