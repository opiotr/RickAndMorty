//
//  FavoriteCharactersStorage.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 20/07/2023.
//

import Foundation
import Combine

final class FavoriteCharactersStorage {
    private let favoriteCharacterIdsKey = "FavoriteCharacterIdsKey"
    private let userDefaults: UserDefaults
    
    var favoritesChangedPublisher: AnyPublisher<[Int], Never> {
        NotificationCenter.default.publisher(for: .favoriteCharactersChanged)
            .compactMap { $0.object as? [Int] }
            .eraseToAnyPublisher()
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func add(_ value: Int) {
        var favorites = getAllValues()
        favorites.insert(value, at: 0)
        userDefaults.set(favorites, forKey: favoriteCharacterIdsKey)

        NotificationCenter.default.post(name: .favoriteCharactersChanged, object: favorites)
    }
    
    func remove(_ value: Int) {
        var favorites = getAllValues()
        favorites.removeAll(where: { $0 == value })
        userDefaults.set(favorites, forKey: favoriteCharacterIdsKey)

        NotificationCenter.default.post(name: .favoriteCharactersChanged, object: favorites)
    }
    
    func remove(_ values: [Int]) {
        var favorites = getAllValues()
        favorites.removeAll(where: { values.contains($0) })
        userDefaults.set(favorites, forKey: favoriteCharacterIdsKey)

        NotificationCenter.default.post(name: .favoriteCharactersChanged, object: favorites)
    }
    
    func getAllValues() -> [Int] {
        userDefaults.array(forKey: favoriteCharacterIdsKey) as? [Int] ?? []
    }
    
    func isFavorite(with id: Int) -> Bool {
        getAllValues().contains(id)
    }
}

private extension Notification.Name {
    static let favoriteCharactersChanged = Notification.Name("FavoriteCharactersChanged")
}
