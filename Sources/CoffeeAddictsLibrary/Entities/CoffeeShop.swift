//
//  File.swift
//  
//
//  Created by Mihai Garda Popescu on 23.07.2021.
//

import Foundation
import CoreLocation

struct CoffeeShop: CustomStringConvertible {
    let name: String
    let coords: CLLocation
    
    var description : String {
        return "\(name) - (\(coords.coordinate.latitude), \(coords.coordinate.longitude))"
    }

}
