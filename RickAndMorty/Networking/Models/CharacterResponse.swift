//
//  CharacterResponse.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 17/07/2023.
//

import Foundation

struct CharacterResponse: Decodable {
    let id: Int
    let name: String
    let status: CharacterStatusResponse
    let species: String
    let type: String
    let gender: CharacterGenderResponse
    let origin: CharacterOriginResponse
    let location: CharacterLocationResponse
    let image: URL
}

enum CharacterStatusResponse: String, Decodable {
    case dead = "Dead"
    case alive = "Alive"
    case unknown
}

enum CharacterGenderResponse: String, Decodable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown
}

struct CharacterOriginResponse: Decodable {
    let name: String
}

struct CharacterLocationResponse: Decodable {
    let name: String
}
