//
//  FavoriteCharactersViewModel.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 20/07/2023.
//

import Foundation
import Combine

final class FavoriteCharactersViewModel: ObservableObject {
    enum State {
        case contentReady
        case loading
        case error
    }

    @Published private(set) var items: [Character] = []
    @Published private(set) var state: State = .loading
    
    private let repository: CharactersRepositoryProtocol
    private let favoriteStorage: FavoriteCharactersStorage
    private var cancellables = Set<AnyCancellable>()
    
    init(
        repository: CharactersRepositoryProtocol = CharactersRepository(),
        favoriteStorage: FavoriteCharactersStorage = FavoriteCharactersStorage()
    ) {
        self.repository = repository
        self.favoriteStorage = favoriteStorage
        
        bind()
    }
    
    func fetchFavorites() async {
        let favoriteIds = favoriteStorage.getAllValues()
        guard !favoriteIds.isEmpty else {
            await MainActor.run { state = .contentReady }
            return
        }

        do {
            let data = try await repository.fetchCharacters(withIds: favoriteIds)
            await MainActor.run {
                items = data
                state = .contentReady
            }
        } catch {
            await MainActor.run {
                state = .error
            }
        }
    }
    
    func removeFromFavorites(itemsAt indexSet: IndexSet) {
        let ids = indexSet.map { items[$0].id }
        favoriteStorage.remove(ids)
    }
    
    private func bind() {
        favoriteStorage.favoritesChangedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ids in
                self?.handleFavoritesUpdate(favoriteIds: ids)
            }
            .store(in: &cancellables)
    }
    
    private func handleFavoritesUpdate(favoriteIds: [Int]) {
        if favoriteIds.count > items.count {
            Task {
                await fetchFavorites()
            }
        } else {
            items.removeAll(where: { !favoriteIds.contains($0.id) })
        }
    }
}
