import SwiftUI
import UsefulDecode

// Dependency Injection
// 1. Protocol-based
// 2. Bag of closures

protocol SWAPIClientProtocol {
    func fetchPeople() async throws -> People
}

class SWAPIClient: SWAPIClientProtocol {
    func fetchPeople() async throws -> People {
        let url = URL(string: "https://swapi.dev/api/people/")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let people = try JSONDecoder().decodeWithBetterErrors(People.self, from: data)
        return people
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

    let client: any SWAPIClientProtocol

    init(client: any SWAPIClientProtocol) {
        self.client = client
    }

    @MainActor
    func loadData() async {
        state = .loading
        do {
            let people = try await client.fetchPeople()
            self.state = .loaded(people)
        } catch {
            self.state = .failed(error: String(describing: error))
            print("Error loading data: \(error)")
        }
    }
}

struct ContentView: View {

    @StateObject var viewModel = ViewModel(client: SWAPIClient())

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
