//
//  CharacterMock.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 19/07/2023.
//

import Foundation

extension Character {
    static let mock = Character(
        id: 1,
        name: "John Doe",
        status: .alive,
        species: "Human",
        type: "",
        gender: .female,
        originName: "Space",
        locationName: "Earth",
        image: URL(string: "https://picsum.photos/300/300")!
    )
}
