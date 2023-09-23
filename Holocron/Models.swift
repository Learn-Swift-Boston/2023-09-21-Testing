import Foundation

struct People: Codable, Equatable {
    let people: [Person]

    enum CodingKeys: String, CodingKey {
        case people = "results"
    }
}

struct Person: Codable, Equatable, Identifiable {
    let name, height, mass, hairColor: String
    let skinColor, eyeColor, birthYear: String
    let gender: Gender
    let homeworld: String
    let films, species, vehicles, starships: [String]
    let created, edited: String
    let url: String

    var id: String {
        name
    }

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films, species, vehicles, starships, created, edited, url
    }
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
    case nA = "n/a"
}

struct Planets {
    // TODO: planets would go here
}
