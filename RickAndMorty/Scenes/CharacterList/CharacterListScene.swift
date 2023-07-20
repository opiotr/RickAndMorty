//
//  CharacterListScene.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 17/07/2023.
//

import SwiftUI

struct CharacterListScene: View {
    @StateObject var viewModel: CharacterListViewModel

    var body: some View {
        VStack {
            switch viewModel.state {
            case .contentReady:
                content
            case .loading:
                ProgressView()
            case .error:
                error
            case .noSearchResults:
                noSearchResults
            }
        }
        .task {
            await viewModel.fetchInitialData()
        }
        .navigationTitle("Characters")
        .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer)
    }
    
    @ViewBuilder
    private var content: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 6) {
                ForEach(viewModel.items) { item in
                    NavigationLink {
                        CharacterDetailsScene(viewModel: .init(character: item))
                    } label: {
                        CharacterView(data: item)
                            .onAppear {
                                Task {
                                    await viewModel.fetchMoreDataIfNeeded(after: item)
                                }
                            }
                    }
                }
            }
            .padding(10)
        }
    }
    
    @ViewBuilder
    private var error: some View {
        ErrorView {
            Task {
                await viewModel.fetchInitialData(forced: true)
            }
        }
    }
    
    @ViewBuilder
    private var noSearchResults: some View {
        Text("No results for '\(viewModel.searchQuery)'")
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
    }
}

struct CharacterListScene_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListScene(viewModel: .init())
            .preferredColorScheme(.dark)
    }
}
