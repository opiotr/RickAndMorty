//
//  CharacterDetailsViewModel.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 17/07/2023.
//

import Foundation
import Combine

final class CharacterDetailsViewModel: ObservableObject {
    @Published private(set) var data: Character
    @Published private(set) var isFavorite = false
    
    let toggleFavorite = PassthroughSubject<Void, Never>()
    
    private let favoriteStorage: FavoriteCharactersStorage
    private var cancellables = Set<AnyCancellable>()
    
    init(
        character: Character,
        favoriteStorage: FavoriteCharactersStorage = FavoriteCharactersStorage()
    ) {
        self.data = character
        self.favoriteStorage = favoriteStorage
        self.isFavorite = favoriteStorage.isFavorite(with: character.id)
        
        bind()
    }
    
    private func bind() {
        toggleFavorite
            .handleEvents(receiveOutput: { [weak self] in
                self?.isFavorite.toggle()
            })
            .debounce(for: .milliseconds(250), scheduler: DispatchQueue.main)
            .compactMap { [weak self] _ -> (Bool, Int)? in
                guard let self else { return nil }

                return (self.isFavorite, self.data.id)
            }
            .sink { [weak self] isFavorite, id in
                if isFavorite {
                    self?.favoriteStorage.add(id)
                } else {
                    self?.favoriteStorage.remove(id)
                }
            }
            .store(in: &cancellables)
        
        favoriteStorage.favoritesChangedPublisher
            .map { [weak self] in
                guard let id = self?.data.id else { return false }
                
                return $0.contains(id)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isFavorite)
    }
}
