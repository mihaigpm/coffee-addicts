//
//  File.swift
//  
//
//  Created by Mihai Garda Popescu on 23.07.2021.
//

import Foundation
import CoreLocation

class CoffeeShopsLocationHelper {
    static func closestLocation(locations: [CoffeeShop], closestToLocation location: CLLocation) -> [CoffeeShop] {
        let closestLocation = locations.sorted(by: { location.distance(from: $0.coords) < location.distance(from: $1.coords) })
        
        return closestLocation
    }
    
    static func distanceBetweenCoordinates(x: CLLocation, y: CLLocation) -> Double {
        return x.distance(from: y).inKilometers().rounded(toPlaces: 4)
    }
    
    static func locationIsValid(location: CLLocation) -> Bool {
        return (location.coordinate.latitude > -90 && location.coordinate.latitude < 90) && (location.coordinate.longitude > -180 && location.coordinate.longitude < 180)
    }
}
