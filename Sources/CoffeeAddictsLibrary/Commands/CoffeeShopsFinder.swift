//
//  File.swift
//  
//
//  Created by Mihai Garda Popescu on 23.07.2021.
//

import ArgumentParser
import CoreLocation

public enum Command {}

extension Command {
    public struct CoffeeShopsFinder: ParsableCommand {
        public init() {}
        public static var configuration = CommandConfiguration(
            commandName: "find-shops",
            abstract: "Returns a list of the three closest coffee shops"
        )

        @Argument(help: "Your X Coordinate")
        var xCoord: Double

        @Argument(help: "Your Y Coordinate")
        var yCoord: Double

        @Argument(help: "Coffee Shops CSV file URL")
        var csvUrl: String

        public func run() throws {
            CoffeeShopsCSVDownloader.downloadCSVFileFromURLString(csvUrl) { csvString, status in
                guard status == .CSVFileDownloadSuccess else {
                    print("Unable to download the CSV file, please try again later.")
                    return
                }
                
                if let string = csvString {
                    CoffeeShopsCSVParser.parseCSVString(string) { result, parsingStatus in
                        if parsingStatus == .CSVFileEmptyResult {
                            print("Couldn't find any close coffee shops to you :(")
                            return
                        }
                        
                        if parsingStatus != .CSVParsingSuccess {
                            print("Unable to parse the submitted CSV file. Please provide another one.")
                            return
                        }
                        
                        let userLocation = CLLocation(latitude: xCoord, longitude: yCoord)
                        let coffeeShops = CoffeeShopsLocationHelper.closestLocation(locations: result, closestToLocation: userLocation)
                        
                        self.displayShops(coffeeShops, userLocation: userLocation)
                    }
                }
            }
        }
        
        func displayShops(_ coffeeShops: [CoffeeShop], userLocation: CLLocation) {
            if coffeeShops.count >= Constants.numberOfShopsToReturn {
                print("The closest coffee shops to you are:")
                for shop in coffeeShops.prefix(Constants.numberOfShopsToReturn) {
                    print("\(shop.description) - \(CoffeeShopsLocationHelper.distanceBetweenCoordinates(x: shop.coords, y: userLocation)) km")
                }
            }
        }
    }
}
