//
//  Character.swift
//  RickAndMorty
//
//  Created by Piotr Olech on 18/07/2023.
//

import Foundation

struct Character: Identifiable, Hashable {
    enum Status: String {
        case dead = "Dead"
        case alive = "Alive"
        case unknown
        
        var name: String {
            rawValue.capitalized
        }
        
        init(from response: CharacterStatusResponse) {
            switch response {
            case .alive:
                self = .alive
            case .dead:
                self = .dead
            case .unknown:
                self = .unknown
            }
        }
    }
    enum Gender: String {
        case female = "Female"
        case male = "Male"
        case genderless = "Genderless"
        case unknown
        
        var name: String {
            rawValue
        }
        
        init(from response: CharacterGenderResponse) {
            switch response {
            case .female:
                self = .female
            case .male:
                self = .male
            case .genderless:
                self = .genderless
            case .unknown:
                self = .unknown
            }
        }
    }

    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let originName: String
    let locationName: String
    let image: URL
    
    init(from response: CharacterResponse) {
        self.id = response.id
        self.name = response.name
        self.status = Status(from: response.status)
        self.species = response.species
        self.type = response.type
        self.gender = Gender(from: response.gender)
        self.originName = response.origin.name
        self.locationName = response.location.name
        self.image = response.image
    }
    
    init(
        id: Int,
        name: String,
        status: Character.Status,
        species: String,
        type: String,
        gender: Character.Gender,
        originName: String,
        locationName: String,
        image: URL
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.originName = originName
        self.locationName = locationName
        self.image = image
    }
}
