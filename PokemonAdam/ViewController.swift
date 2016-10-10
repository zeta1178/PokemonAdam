//
//  ViewController.swift
//  PokemonAdam
//
//  Created by Michael Cruz on 9/30/16.
//  Copyright © 2016 MIchael Cruz. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var updateCount = 0
    
    var manager = CLLocationManager()
    
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            setUp()
            
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.setUp()
        }
    }
    
    
    func setUp() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            //Spawn a Pokemon
            
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let anno = PokeAnnontation(coord: coord, pokemon: pokemon)
                anno.coordinate = coord
                let randoLat = (Double(arc4random_uniform(200))-100.0) / 50000.0
                let randoLon = (Double(arc4random_uniform(200))-100.0) / 50000.0
                anno.coordinate.latitude += randoLat
                anno.coordinate.longitude += randoLon
                self.mapView.addAnnotation(anno)
                
            }
            
        })
 
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            annoView.image = UIImage(named: "player")
            
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            annoView.frame = frame
            
            return annoView
        }
        
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let pokemon = (annotation as! PokeAnnontation).pokemon
        annoView.image = UIImage(named: pokemon.imageName!)
        
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        
        return annoView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200,200)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        if view.annotation! is MKUserLocation {
            return
        }
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200,200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = (view.annotation! as! PokeAnnontation).pokemon
                
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    
                
                
                    pokemon.caught = true
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                mapView.removeAnnotation(view.annotation!)
                    
                 
                    let alertVC = UIAlertController(title: "Congrats!", message: "You caught a \(pokemon.name!). You are a Pokemon master", preferredStyle: .alert)
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                    
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    alertVC.addAction(pokedexAction)
                    let OKaction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                    
                } else {
                    
                    let alertVC = UIAlertController(title: "Uh-oh", message: "You are too far away to catch the \(pokemon.name!). Move closer to it", preferredStyle: .alert)
                    let OKaction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        })
        
        if let coord = manager.location?.coordinate {
            
            if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                print("Can catch the Pokemon")
            } else {
                print("too far away")
            }
        }
    }
    
    @IBAction func centerTap(_ sender: AnyObject) {
        
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200,200)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    
}
