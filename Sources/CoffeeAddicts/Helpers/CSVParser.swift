//
//  File.swift
//  
//
//  Created by Mihai Garda Popescu on 23.07.2021.
//

import Foundation
import CoreLocation

typealias CoffeeShopsResult = ([CoffeeShop], ParsingStatus) -> Void

class CSVParser {
    static func parseCSVString(_ string: String, completion: @escaping CoffeeShopsResult) {
        var coffeeShops: [CoffeeShop] = []
        
        let parsedCSV: [[String]] = string.components(separatedBy: "\n").map{ $0.components(separatedBy: ",") }
        print(parsedCSV)
        
        if parsedCSV.count == 0 {
            // CSV file empty or invalid
            print("log csv file empty or invalid")
            completion([], .CSVFileInvalid)
        }
        
        for line in parsedCSV {
            if let lat = Double(line[1]), let lng = Double(line[2]) {
                let coffeeShop: CoffeeShop = CoffeeShop(name: line[0], coords: CLLocation(latitude: lat, longitude: lng))
                coffeeShops.append(coffeeShop)
            } else {
                print("log line invalid, ignoring")
                continue
            }
        }
        
        if coffeeShops.count == 0 {
            print("log csv file empty or invalid")
            completion([], .CSVFileEmptyResult)
        }
        
        completion(coffeeShops, .CSVParsingSuccess)
    }
    
    
}
