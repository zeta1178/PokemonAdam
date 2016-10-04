//
//  PokeAnnotation.swift
//  PokemonAdam
//
//  Created by Michael Cruz on 10/3/16.
//  Copyright © 2016 MIchael Cruz. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnontation : NSObject, MKAnnotation {
    
   var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init (coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
    
}

