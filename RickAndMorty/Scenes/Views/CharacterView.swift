//
//  CharacterView.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 19/07/2023.
//

import SwiftUI

struct CharacterView: View {
    let data: Character

    var body: some View {
        HStack {
            AsyncImage(url: data.image, transaction: .init(animation: .easeInOut)) {
                switch $0 {
                case .success(let image):
                    image
                        .resizable()
                        .clipShape(Circle())
                        .transition(.opacity)
                case .failure:
                    PlaceholderImage()
                case .empty:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            .frame(width: 80, height: 80)
            
            VStack(alignment: .leading) {
                Text(data.name)
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.leading)
                
                Text(data.species)
                    .font(.subheadline)
                
                Spacer()
                
                StatusView(status: data.status)
            }
            .foregroundColor(.white)

            Spacer()
        }
        .frame(height: 95)
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(
            Color.gray
                .opacity(0.2)
                .cornerRadius(10)
        )
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(data: .mock)
    }
}
