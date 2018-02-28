//
//  mapsViewController.swift
//  Take me home
//
//  Created by Dozie Enwerem on 2018-01-24.
//  Copyright © 2018 Dozie Enwerem. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON


/*enum Location {
    case startLocation
    case destinationLocation
}*/

class mapsViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMaps: GMSMapView!
    
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var addressLong: Double?
    var addressLat: Double?
    
    var path: Int = 0
    
    var googleAPIKey = "AIzaSyBKVWT2WIqhzIdDirSb0qG8Bu09F5_lwKg"
    
    var color:UIColor = UIColor.blue
    
    var currLong: Double?
    var currLat: Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.infoWind = loadNiB()
        
        
        print("enters view did load")
       
        print("These are the home address coordinates " + "\(String(describing: addressLong))" + " " + "\(String(describing: addressLat))")
        
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()

        
        //let camera = GMSCameraPosition.camera(withLatitude: 43.5944837, longitude: -79.64763570000002, zoom: 10.0)
        
        //self.googleMaps.camera = camera
        self.googleMaps.delegate = self
        self.googleMaps.settings.compassButton = true
        self.googleMaps.settings.zoomGestures = true
        
        
        
        
        //setStartLocation()
        //setDestLocation()
        
        
        //showBusDirection()
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        showBusDirection()
    }*/
    
    //MARK: function for creating a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        //var windInfo: UIImage = infoWindow() as UIImage
        print("enters createMarker")
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        //marker.snippet = "Snippet"
        //marker.iconView = infoWindow()
        marker.map = googleMaps
        
        
    }
    
    func createTransitMarker(transitType: String, transitName: String, stopName: String,arrTime: String, depTime: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        //var windInfo: UIImage = infoWindow() as UIImage
        print("enters createMarker")
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = transitType + " " + transitName + "(@ \(stopName))"
        marker.icon = iconMarker
        marker.snippet = depTime + " - " + arrTime
        //marker.iconView = infoWindow()
        marker.map = googleMaps
    }
    
    //MARK: Location Manager delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Error getting location: \(error)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("enters locationManager")
        
        //DO NOT DELETE - This is for getting users current location
        if let location = locations.first {
            
            
            self.googleMaps.camera = GMSCameraPosition(target: location.coordinate, zoom: 6, bearing: 0, viewingAngle: 0)
            
            
            locationManager.stopUpdatingLocation()
        }
        
        /*let locationDest = CLLocation(latitude: addressLat!, longitude: addressLong!)
        
        let location = CLLocation(latitude: 43.5944837, longitude: -79.64763570000002)
        
        createMarker(titleMarker: "Home", iconMarker: #imageLiteral(resourceName: "homeicon"), latitude: addressLat!, longitude: addressLong!)
        
        createMarker(titleMarker: "Origin", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: 43.5944837, longitude: -79.64763570000002)
        
        drawPath(startLocation: location, endLocation: locationDest)*/
        
        //self.locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        /*if (locationMarker != nil){
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return
            }
            infoWind.center = mapView.projection.point(for: location)
            infoWind.center.y = infoWind.center.y - 82
        }*/
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //infoWind.removeFromSuperview()
    }
    
    /*func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWind.removeFromSuperview()
    }*/
    //DO NOT DELETE - This is for getting users current location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            
            self.googleMaps.isMyLocationEnabled = true
            self.googleMaps.settings.myLocationButton = true
        }
    }
    
    
    
    
    // MARK: GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
        
        currLat = position.target.latitude
        currLong = position.target.longitude
        
        
        
        let locationDest = CLLocation(latitude: addressLat!, longitude: addressLong!)
        
        let location = CLLocation(latitude: currLat!, longitude: currLong!)
        
        createMarker(titleMarker: "Destination", iconMarker: #imageLiteral(resourceName: "destination"), latitude: addressLat!, longitude: addressLong!)
        
        createMarker(titleMarker: "Origin", iconMarker: #imageLiteral(resourceName: "origin"), latitude: currLat!, longitude: currLong!)
        
        drawPath(startLocation: location, endLocation: locationDest)
        
        self.locationManager.stopUpdatingLocation()
        
        print("users current coords \(String(describing: currLong))  \(String(describing: currLat))")
    }
    
    /*func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1?.text = "Hi there!"
        view.addSubview(lbl1!)
        
        let lbl2 = UILabel(frame: CGRect.init(x: (lbl1?.frame.origin.x)!, y: (lbl1?.frame.origin.y)! + (lbl1?.frame.size.height)! + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        let lbl3 = UILabel(frame: CGRect.init(x: lbl2.frame.origin.x, y: lbl2.frame.origin.y + lbl2.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl3.text = "I am the second custom info window."
        lbl3.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl3)
        
        
        
        return view
    }*/
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        googleMaps.isMyLocationEnabled = true
        
        if(gesture){
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        googleMaps.isMyLocationEnabled = true
        
        /*var markerData : NSDictionary?
        if let data = marker.userData! as? NSDictionary {
            markerData = data
        }
        locationMarker = marker*/
        /*infoWind.removeFromSuperview()
        infoWind = loadNiB()
        guard let location = locationMarker?.position else {
            print("locationMarker is nil")
            return false
        }
        // Pass the spot data to the info window, and set its delegate to self
        infoWind.spotData = markerData
        //infoWind.delegate = self as? MapMarkerDelegate
        // Configure UI properties of info window
        infoWind.alpha = 0.9
        infoWind.layer.cornerRadius = 12
        infoWind.layer.borderWidth = 2
        //infoWind.layer.borderColor = UIColor.blue as? CGColor
        //infoWind.infoButton.layer.cornerRadius = infoWindow.infoButton.frame.height / 2
        
        let address = markerData!["address"]!
        let rate = markerData!["rate"]!
        let fromTime = markerData!["fromTime"]!
        let toTime = markerData!["toTime"]!
        
        infoWind.transitType.text = address as? String
        infoWind.transitName.text = "transit name"
        infoWind.stopName.text = "stop name"
        infoWind.depTime.text = "$\(String(format:"%.02f", (rate as? Float)!))/hr"
        infoWind.arrTime.text = "$\(String(format:"%.02f", (rate as? Float)!))/hr"


        // Offset the info window to be directly above the tapped marker
        infoWind.center = mapView.projection.point(for: location)
        infoWind.center.y = infoWind.center.y - 82
        self.view.addSubview(infoWind)*/
        return false
    }
    
    /*func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)")
    }*/
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.isMyLocationEnabled = true
        googleMaps.selectedMarker = nil
        return false
    }
    
    
    
    //MARK: function for creating direction path from start location to destination
    func drawPath(startLocation: CLLocation, endLocation: CLLocation){
        path += 1
        
        switch path {
        case 1:
            color = UIColor.red
        case 2:
            color = UIColor.blue
        case 3:
            color = UIColor.darkGray
        default:
            color = UIColor.green
        }
        print("enters drawPath")
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=transit"
        
        /*https://maps.googleapis.com/maps/api/directions/json?origin=75+9th+Ave+New+York,+NY&destination=MetLife+Stadium+1+MetLife+Stadium+Dr+East+Rutherford,+NJ+07073&mode=transit&arrival_time=1391374800&key=YOUR_API_KEY*/
        
        
        
        Alamofire.request(url).responseJSON { (response) in
            
            //print("this is the request \(response.request as Any)") //original URL request
            //print("this is the response \(response.response as Any)") //HTTP URL response
            //print("this is the data \(response.data as Any)") //server data
            //print("this is the result \(response.result as Any)") //result of response serialization
            //short_name is bus number, headsign is bus number plus name
            
            let json: JSON
            
            do {
            json = try JSON(data: response.data!)
            }
            
            catch _ {
                json = JSON.null
            }
            
            
            
            self.getBusInfo(json: json)
            print("this is it \(json)")
            let routes = json["routes"].arrayValue
            
            
            
            for route in routes{
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 5
                polyline.strokeColor = self.color
                polyline.map = self.googleMaps
            }
        }
        
    
    }
    
    func showBusDirection(){
        print("enters showBusDirection")
        self.drawPath(startLocation: locationStart, endLocation: locationEnd)
    }
    
    func getBusInfo(json: JSON){
        //print("this is it \(json)")
        
        
        //let lat = json["routes"][0]["legs"][0]["start_location"]["lat"].doubleValue
        var index: Int = 0
        var count: Int = 0
        var transitNum: JSON = json["routes"][0]["legs"][0]["steps"][index]["transit_details"]
        var transitLong:[Double] = []
        var transitLat:[Double] = []
        var transitType:[String] = []
        var transitName:[String] = []
        var transitStopName:[String] = []
        var transitDepTime:[String] = []
        var transitArrTime:[String] = []



        /*if(json == JSON.null){
            
            let alertController = UIAlertController(title: "Transit unavailable", message: "Unfortunately there is no transit information for your current location", preferredStyle: .alert)
           
            
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: ({ (action) in
              
                }
                
            ))
            
            
            
            alertController.addAction(confirmAction)
            
            present(alertController, animated: true, completion: nil)
        }*/
        
        //else{
        while transitNum == JSON.null{
            index += 1
            transitNum = json["routes"][0]["legs"][0]["steps"][index]["transit_details"] //for finding transit details
        }


        while transitNum != JSON.null{
            transitLong.insert(json["routes"][0]["legs"][0]["steps"][index]["transit_details"]["departure_stop"]["location"]["lng"].doubleValue, at: count)
            transitLat.insert(json["routes"][0]["legs"][0]["steps"][index]["transit_details"]["departure_stop"]["location"]["lat"].doubleValue, at: count)
            transitType.insert(json["routes"][0]["legs"][0]["steps"][index]["transit_details"]["line"]["vehicle"]["name"].stringValue, at: count)
            transitName.insert(json["routes"][0]["legs"][0]["steps"][index]["transit_details"]["line"]["short_name"].stringValue, at: count)
            transitStopName.insert(json["routes"][0]["legs"][0]["steps"][index]["transit_details"]["departure_stop"]["name"].stringValue, at: count)
            transitDepTime.insert(json["routes"][0]["legs"][0]["steps"][index]["transit_details"]["departure_time"]["text"].stringValue, at: count)
            transitArrTime.insert(json["routes"][0]["legs"][0]["steps"][index]["transit_details"]["arrival_time"]["text"].stringValue, at: count)

            //print("This is the transit \(transitLong)")
            index += 2
            count += 1
            transitNum = json["routes"][0]["legs"][0]["steps"][index]["transit_details"]
            //print("This is the transit count \(count)")
        }

        
            print("This is the transit longs \(transitLong)")
            print("This is the transit lats \(transitLat)")
            print("This is the transit types \(transitType)")
            print("This is the transit name \(transitName)")
            print("This is the transit stop name \(transitStopName)")
            print("This is the transit dep time \(transitDepTime)")
            print("This is the transit arr time \(transitArrTime)")
        
    

        for i in 0...(transitStopName.count - 1){
            
            /*var text = "<div>Transit type: \(transitType[i]) <br> " +  "Transit number: \(transitName[i]) \n Stop name: \(transitStopName[i]) \n Depature time: \(transitDepTime[i]) \n Arrival time: \(transitArrTime[i])"*/
            
            print("it enters here")
            
            
            createTransitMarker(transitType: transitType[i], transitName: transitName[i], stopName: transitStopName[i],arrTime: transitArrTime[i], depTime: transitDepTime[i], iconMarker: #imageLiteral(resourceName: "transit"), latitude: transitLat[i], longitude: transitLong[i])
            }

        }
    //}

}
