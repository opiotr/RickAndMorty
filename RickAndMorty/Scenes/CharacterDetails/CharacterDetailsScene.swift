//
//  CharacterDetailsScene.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 17/07/2023.
//

import SwiftUI

struct CharacterDetailsScene: View {
    @StateObject var viewModel: CharacterDetailsViewModel

    var body: some View {
        ScrollView {
            VStack {
                profileImage
                name
                metadata
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { viewModel.toggleFavorite.send() }) {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    @ViewBuilder
    private var profileImage: some View {
        VStack(spacing: 0) {
            AsyncImage(url: viewModel.data.image, transaction: .init(animation: .easeInOut)) {
                switch $0 {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    PlaceholderImage()
                case .empty:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            .frame(height: 200)
            .overlay {
                RoundedRectangle(cornerRadius: 100)
                    .stroke(viewModel.data.status.accentColor, lineWidth: 10)
            }
            .clipShape(Circle())
            
            StatusView(status: viewModel.data.status)
        }
    }
    
    @ViewBuilder
    private var name: some View {
        Text(viewModel.data.name)
            .font(.largeTitle)
            .bold()
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private var metadata: some View {
        VStack(spacing: 0) {
            MetadataRow(
                iconName: "person.fill.viewfinder",
                title: "Species",
                text: viewModel.data.species.capitalized
            )
            
            MetadataRow(
                iconName: "figure.dress.line.vertical.figure",
                title: "Gender",
                text: viewModel.data.gender.name.capitalized
            )
            
            MetadataRow(
                iconName: "map.fill",
                title: "Origin",
                text: viewModel.data.originName.capitalized
            )
            
            MetadataRow(
                iconName: "pin.fill",
                title: "Location",
                text: viewModel.data.locationName.capitalized
            )
        }
    }
}

private struct MetadataRow: View {
    let iconName: String
    let title: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconName)
                .frame(width: 25, height: 25)
                .font(.title3)
                .bold()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.callout)
                
                Text(text)
                    .font(.title3)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding()
        .background(
            Color.gray
                .opacity(0.2)
                .cornerRadius(10)
        )
        .padding(.vertical, 2)
    }
}

struct CharacterDetailsScene_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailsScene(
            viewModel: .init(character: .mock)
        )
    }
}
