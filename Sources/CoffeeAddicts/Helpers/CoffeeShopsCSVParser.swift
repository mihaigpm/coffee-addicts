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
        var coffeeShops: [CoffeeShop] = []
        
        let parsedCSV: [[String]] = string.components(separatedBy: "\n").map{ $0.components(separatedBy: ",") }
        print(parsedCSV)
        
        if parsedCSV.count == 0 {
            completion([], .CSVFileInvalid)
        }
        
        for line in parsedCSV {
            if let lat = Double(line[1].trimmingCharacters(in: .newlines)), let lng = Double(line[2].trimmingCharacters(in: .newlines)) {
                let coffeeShop: CoffeeShop = CoffeeShop(name: line[0], coords: CLLocation(latitude: lat, longitude: lng))
                coffeeShops.append(coffeeShop)
            } else {
                // Ignoring invalid line
                continue
            }
        }
        
        if coffeeShops.count == 0 {
            completion([], .CSVFileEmptyResult)
        }
        
        completion(coffeeShops, .CSVParsingSuccess)
    }
    
    
}
