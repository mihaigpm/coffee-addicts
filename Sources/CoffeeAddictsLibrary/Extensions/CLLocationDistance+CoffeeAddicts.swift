//
//  File.swift
//  
//
//  Created by Mihai Garda Popescu on 23.07.2021.
//

import Foundation
import CoreLocation

extension CLLocationDistance {
    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}
