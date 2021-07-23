//
//  File.swift
//  
//
//  Created by Mihai Garda Popescu on 23.07.2021.
//

import ArgumentParser
import CoreLocation

extension Command {
    struct ShopsFinder: ParsableCommand {
        static var configuration: CommandConfiguration {
          .init(
            commandName: "find-shops",
            abstract: "Returns a list of the three closest coffee shops"
          )
        }

        @Argument(help: "Your X Coordinate")
        var xCoord: Double

        @Argument(help: "Your Y Coordinate")
        var yCoord: Double

        @Argument(help: "Coffee Shops CSV file URL")
        var csvUrl: String

        func run() throws {
            Downloader.downloadCSVFileFromURLString(csvUrl) { csvString, status in
                if status == .CSVFileDownloadSuccess {
                    if let string = csvString {
                        CSVParser.parseCSVString(string) { result, parsingStatus in
                            if parsingStatus == .CSVFileEmptyResult {
                                print("Couldn't find any close coffee shops to you :(")
                                return
                            }
                            
                            if parsingStatus != .CSVParsingSuccess {
                                print("Unable to parse the submitted CSV file. Please provide another one.")
                                return
                            }
                            
                            let userLocation = CLLocation(latitude: xCoord, longitude: yCoord)
                            let coffeeShops = LocationHelper.closestLocation(locations: result, closestToLocation: userLocation)
                            
                            print("The closest coffee shops to you are:")
                            for shop in coffeeShops.prefix(3) {
                                print("\(shop.description) - \(LocationHelper.distanceBetweenCoordinates(x: shop.coords, y: userLocation)) km")
                            }
                        }
                    }
                } else {
                    print("Unable to download the CSV file, please try again later.")
                }
            }
        }
    }
}
