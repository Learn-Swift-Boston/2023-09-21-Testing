import Foundation

struct World {
    var client: SWAPIClient
    // TODO: more clients and stuff
}

let isTesting = NSClassFromString("XCTest") != nil

var Current = World(
    client: isTesting ? .test : .live
)
