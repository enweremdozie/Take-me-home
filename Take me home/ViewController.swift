//
//  ViewController.swift
//  Take me home
//
//  Created by Dozie Enwerem on 2018-01-20.
//  Copyright © 2018 Dozie Enwerem. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var addressLong: Double?
    var addressLat: Double?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    //var addStatus: bool = false

    @IBAction func homeButton(_ sender: UIButton) {
        let addState = UserDefaults.standard.bool(forKey: "addStatus")
        
        if addState == true{
        performSegue(withIdentifier: "mapSegue", sender: self)
        }
        
        else{
                let alertController = UIAlertController(title: "No address saved", message: "There is no saved address, please use the search bar above to save your address", preferredStyle: .alert)
                
                
                let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: ({ (action) in
                    }
                    
                ))
                
                
                
                alertController.addAction(confirmAction)
                
                present(alertController, animated: true, completion: nil)
                
                
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let introMsg = UserDefaults.standard.bool(forKey: "readMsg")
        //print("enters view did load")
        
        if let addresslongitude = UserDefaults.standard.value(forKey: "addressLong") as? Double {
            addressLong = addresslongitude
        }
        
        if let addresslatitude = UserDefaults.standard.value(forKey: "addressLat") as? Double {
            addressLat = addresslatitude
        }
        
        
        
        if introMsg == false{
            let alertController = UIAlertController(title: "Saving your address", message: "1. Search for your address in the search bar above \n 2. Click on your address, this saves your address for the future so you never have to search again unless you want to change your address", preferredStyle: .alert)
            
            
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: ({ (action) in
                
                UserDefaults.standard.set(true, forKey: "readMsg")

                print("ok clicked")
                }
                
            ))
          
            
            
            alertController.addAction(confirmAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self as GMSAutocompleteResultsViewControllerDelegate
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        
        /*if currentAddress.count == 0 {
            updateButton()
        }
        
        
    
        let addButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(updateButton))
        self.navigationItem.rightBarButtonItem = addButton*/
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverVC = segue.destination as! mapsViewController
        
        if let addresslongitude = UserDefaults.standard.value(forKey: "addressLong") as? Double {
           receiverVC.addressLong  = addresslongitude
        }
        
        if let addresslatitude = UserDefaults.standard.value(forKey: "addressLat") as? Double {
            receiverVC.addressLat = addresslatitude
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: function for alert dialog
    @objc func updateButton(savedAddress: GMSPlace){
        /*if (UserDefaults.standard.value(forKey: "address") as? GMSPlace) != nil {
            //currentAddress = savedAddress
            UserDefaults.standard.set(savedAddress, forKey: "address")
        }*/
            
            UserDefaults.standard.set(savedAddress.coordinate.longitude, forKey: "addressLong")
            UserDefaults.standard.set(savedAddress.coordinate.latitude, forKey: "addressLat")

        
        /*else if(UserDefaults.standard.value(forKey: "address") as? GMSPlace) == nil {
            //currentAddress = savedAddress
            UserDefaults.standard.set(savedAddress, forKey: "address")
        }*/
        
        let alertController = UIAlertController(title: "Address Updated", message: "Your address has been saved as \"" + (savedAddress.formattedAddress!) + "\" you can change it at any time", preferredStyle: .alert)
        
        UserDefaults.standard.set(true, forKey: "addStatus")

        /*alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Address"
            textField.delegate = self
        })*/
        
        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: ({ (action) in
            
            //UserDefaults.standard.set(alertController.textFields![0].text, forKey: "address")
            //self.label
            print("Update was clicked")
        }
            
        ))
        
        /*let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: ({ (action) in
            
            print("Cancel was clicked")
        }
        ))*/
        
        
        alertController.addAction(confirmAction)
        //alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
 
    
    //MARK: on press of return address is saved
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //save in db here
        
        UserDefaults.standard.set(textField.text!, forKey: "address")
        return false
    }
    
}
    // Handle the user's selection.
    extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didAutocompleteWith place: GMSPlace) {
            searchController?.isActive = false
            // Do something with the selected place.
            print("Place name: \(place.name)")
            print("Place address: \(String(describing: place.formattedAddress))")
            print("Place attributions: \(String(describing: place.attributions))")
            
            print("Place coordinate: \(place.coordinate)")
            
            updateButton(savedAddress: place)
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didFailAutocompleteWithError error: Error){
            // TODO: handle the error.
            print("Error: ", error.localizedDescription)
        }
        
        // Turn the network activity indicator on and off again.
        func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }



