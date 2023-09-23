import XCTest
@testable import Holocron

final class HolocronTests: XCTestCase {

    func testLoadData() async {
        Current.client.fetchPeople = {
            .init(people: [.luke])
        }
        let viewModel = ViewModel()

        XCTAssertEqual(viewModel.state, .initial)

        await viewModel.loadData()

        XCTAssertEqual(viewModel.state, .loaded(.init(people: [.luke])))
    }

    func testLoadData_error() async {
        Current.client.fetchPeople = {
            struct FailureToLoad: Error, CustomStringConvertible {
                var description: String {
                    "Failed to load."
                }
            }
            throw FailureToLoad()
        }
        let viewModel = ViewModel()
        XCTAssertEqual(viewModel.state, .initial)

        await viewModel.loadData()

        XCTAssertEqual(viewModel.state, .failed(error: "Failed to load."))
    }

}

extension Person {
    static var luke: Self {
        .init(
            name: "Luke Skywalker",
            height: "172",
            mass: "77",
            hairColor: "blond",
            skinColor: "fair",
            eyeColor: "blue",
            birthYear: "19BBY",
            gender: .male,
            homeworld: "https://swapi.dev/api/planets/1/",
            films: ["abcd"],
            species: ["asdf"],
            vehicles: [";likj"],
            starships: ["1234"],
            created: "2014-12-09T13:50:51.644000Z",
            edited: "2014-12-20T21:17:56.891000Z",
            url: "https://swapi.dev/api/people/1/"
        )
    }
}
