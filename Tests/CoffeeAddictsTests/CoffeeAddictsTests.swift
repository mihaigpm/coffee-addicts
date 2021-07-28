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

    func testInvalidLocation() {
        let location = CLLocation(latitude: -91.2, longitude: 182.2)
        let result = CoffeeShopsLocationHelper.locationIsValid(location: location)
        XCTAssertFalse(result)
    }
    
    func testInvalidCSVFile() {
//        let bundle = Bundle(for: type(of: self))
//        let path = bundle.path(forResource: "invalid-csv-shops", ofType: "csv")!
        
        var shops: [CoffeeShop] = []
        CoffeeShopsCSVParser.parseCSVString("Starbucks Seattle47.5809-122.3160\r") { (result, status) in
            shops = result
        }
        
        XCTAssertTrue(shops.count == 0)
    }
    
    func testInvalidCSVLine() {
        var shops: [CoffeeShop] = []

        let csvString = "Starbucks Seattle,47.5809,-122.3160\nStarbucks SF,37.5209,-122.3340\nStarbucks Moscow,corrupt,field\nStarbucks Seattle2,47.5869,-122.3368\nStarbucks Rio De Janeiro,-22.923489,-43.234418\nStarbucks Sydney,-33.871843,151.206767\n"

        
        CoffeeShopsCSVParser.parseCSVString(csvString) { (result, status) in
            shops = result
        }
        
        XCTAssertTrue(shops.count == 5)
    }
    
    func testInvalidCSVLineExtraParam() {
        var shops: [CoffeeShop] = []

        let csvString = "Starbucks Seattle,47.5809,-122.3160\nStarbucks SF,37.5209,-122.3340\nStarbucks Moscow,47.2,23.2,2222\nStarbucks Seattle2,47.5869,-122.3368\nStarbucks Rio De Janeiro,-22.923489,-43.234418\nStarbucks Sydney,-33.871843,151.206767\n"

        
        CoffeeShopsCSVParser.parseCSVString(csvString) { (result, status) in
            shops = result
        }
        
        XCTAssertTrue(shops.count == 5)
    }
    
    func testEmptyCSV() {
        var shops: [CoffeeShop] = []

        let csvString = "        \n"

        CoffeeShopsCSVParser.parseCSVString(csvString) { (result, status) in
            shops = result
        }
        
        XCTAssertTrue(shops.count == 0)
    }
}
