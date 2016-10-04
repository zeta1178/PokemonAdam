//
//  ViewController.swift
//  PokemonAdam
//
//  Created by Michael Cruz on 9/30/16.
//  Copyright © 2016 MIchael Cruz. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var updateCount = 0
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("We are ready to go!")
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                //Spawn a Pokemon
                
                if let coord = self.manager.location?.coordinate {
                let anno = MKPointAnnotation()
                anno.coordinate = coord
                anno.coordinate.latitude += 0.001
                self.mapView.addAnnotation(anno)
                
                }
                
            })
            
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 400,400)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    
    
    @IBAction func centerTap(_ sender: AnyObject) {
        
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 400,400)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    
}
