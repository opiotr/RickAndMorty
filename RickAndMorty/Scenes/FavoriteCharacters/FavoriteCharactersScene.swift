//
//  FavoriteCharactersScene.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 18/07/2023.
//

import SwiftUI

struct FavoriteCharactersScene: View {
    @StateObject var viewModel: FavoriteCharactersViewModel

    var body: some View {
        VStack {
            switch viewModel.state {
            case .contentReady:
                content
            case .loading:
                ProgressView()
            case .error:
                error
            }
        }
        .task {
            await viewModel.fetchFavorites()
        }
        .navigationTitle("Favorites")
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.items.isEmpty {
            Text("There's nothing here 😔")
        } else {
            List {
                ForEach(viewModel.items) { item in
                    ZStack {
                        CharacterView(data: item)

                        NavigationLink {
                            CharacterDetailsScene(viewModel: .init(character: item))
                        } label: {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                }
                .onDelete {
                    viewModel.removeFromFavorites(itemsAt: $0)
                }
                .listRowInsets(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var error: some View {
        ErrorView {
            Task {
                await viewModel.fetchFavorites()
            }
        }
    }
}

struct FavoriteCharactersScene_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteCharactersScene(viewModel: .init())
    }
}
