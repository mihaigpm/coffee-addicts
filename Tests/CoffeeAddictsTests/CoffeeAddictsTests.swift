import XCTest
import class Foundation.Bundle
@testable import CoffeeAddictsLibrary

final class CoffeeAddictsTests: XCTestCase {
    func testValidClosestLocationToUserLocation() {
        let userLocation = CLLocation(latitude: 42.21, longitude: 22.21)
        let coffeeShop = CoffeeShop(name: "Mock Coffee Shop", coords: userLocation)

        let closestLocation = CoffeeShopsLocationHelper.closestLocation(locations: [coffeeShop], closestToLocation: userLocation)

        XCTAssert(closestLocation.count == 1)
    }

//    func testInvalidClosestLocationToUserLocation() {
//        let userLocation = CLLocation(latitude: -5, longitude: 0)
//        let coffeeShop = CoffeeShop(name: "Mock Coffee Shop", coords: CLLocation(latitude: 42.2, longitude: 22.1))
//
//        let closestLocation = CoffeeShopsLocationHelper.closestLocation(locations: [coffeeShop], closestToLocation: userLocation)
//
//        XCTAssert(closestLocation.count == 0)
//    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let fooBinary = productsDirectory.appendingPathComponent("CoffeeAddicts")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Hello, world!\n")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
