//
//  File.swift
//  
//
//  Created by Mihai Garda Popescu on 23.07.2021.
//

import Foundation
import CoreLocation

typealias CoffeeShopsResult = ([CoffeeShop], ParsingStatus) -> Void

class CoffeeShopsCSVParser {
    static func parseCSVString(_ string: String, completion: @escaping CoffeeShopsResult) {
        let parsedCSV: [[String]] = string.components(separatedBy: "\n").map{ $0.components(separatedBy: ",") }
        
        guard parsedCSV.count > 0 else {
            completion([], .CSVFileInvalid)
            return
        }
        
        let coffeeShops = CoffeeShopsCSVParser.coffeeShopsFromParsedCSV(parsedCSV)
        if coffeeShops.count == 0 {
            completion([], .CSVFileEmptyResult)
        }
        
        completion(coffeeShops, .CSVParsingSuccess)
    }
    
    static func coffeeShopsFromParsedCSV(_ parsedCSV: [[String]]) -> [CoffeeShop] {
        var coffeeShops: [CoffeeShop] = []
        
        for line in parsedCSV {
            if line.count != 3 {
                continue
            }
            if let lat = CoffeeShopsCSVParser.sanitizedCoordinateFromString(line[1]),
               let lng = CoffeeShopsCSVParser.sanitizedCoordinateFromString(line[2]) {
                if CoffeeShopsLocationHelper.locationIsValid(location: CLLocation(latitude: lat, longitude: lng)) {
                    let coffeeShop: CoffeeShop = CoffeeShop(name: line[0], coords: CLLocation(latitude: lat, longitude: lng))
                    coffeeShops.append(coffeeShop)
                } else {
                    continue
                }
            } else {
                // Ignoring invalid line
                continue
            }
        }
        
        return coffeeShops
    }
    
    static func sanitizedCoordinateFromString(_ coord: String) -> Double? {
        return Double(coord.trimmingCharacters(in: .newlines))
        
    }
}
