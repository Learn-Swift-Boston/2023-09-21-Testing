import SwiftUI
import UsefulDecode

// Dependency Injection
// 1. Protocol-based
// 2. Bag of closures

struct SWAPIClient {
    var fetchPeople: () async throws -> People
    var fetchPlanets: () async throws -> Planets
}

extension SWAPIClient {
    static var live: Self {
        .init(
            fetchPeople: {
                let url = URL(string: "https://swapi.dev/api/people/")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let people = try JSONDecoder().decodeWithBetterErrors(People.self, from: data)
                return people
            },
            fetchPlanets: {
                .init()
            }
        )
    }

    static var test: Self {
        .init(
            fetchPeople: {
                fatalError("fetchPeople is not implemented")
            },
            fetchPlanets: {
                fatalError("fetchPlanets is not implemented")
            }
        )
    }
}

enum LoadingState: Equatable {
    case initial
    case loading
    case loaded(People)
    case failed(error: String)
}

final class ViewModel: ObservableObject {

    @Published
    var state: LoadingState = .initial

    @MainActor
    func loadData() async {
        state = .loading
        do {
            let people = try await Current.client.fetchPeople()
            self.state = .loaded(people)
        } catch {
            self.state = .failed(error: String(describing: error))
            print("Error loading data: \(error)")
        }
    }
}

struct ContentView: View {

    @StateObject var viewModel = ViewModel()

    var body: some View {
        Group {
            switch viewModel.state {
            case .initial:
                Text("Initial State")
            case .loading:
                ProgressView().progressViewStyle(.circular)
            case .loaded(let people):
                List(people.people) { person in
                    Text(person.name)
                }
            case .failed(let error):
                Text("Failed to load: \(error)")
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}

#Preview {
    ContentView()
}
