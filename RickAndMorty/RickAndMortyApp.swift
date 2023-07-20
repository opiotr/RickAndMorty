//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 17/07/2023.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    CharacterListScene(viewModel: .init())
                }
                .tabItem {
                    Label("Characters", systemImage: "person.3")
                }

                NavigationStack {
                    FavoriteCharactersScene(viewModel: .init())
                }
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
