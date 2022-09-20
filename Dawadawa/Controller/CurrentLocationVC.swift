//
//  CurrentLocationVC.swift
//  Dawadawa
//
//  Created by Alekh on 05/09/22.
//  Developer Name: -  Ritesh Gupta

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


class CurrentLocationVC: UIViewController{
    
    
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var Mapview: GMSMapView!
    @IBOutlet weak var lblcurrentLocation: UILabel!
    
    var Currentaddress : String! = ""
    var latitude = Double()
    var longitude = Double()
    
    var street = ""
    var subLocality = ""
    var city = ""
    var state = ""
    var country = ""
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    
    
    var callback:((String,Double,Double)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let camera = GMSCameraPosition.camera(withLatitude: 1.285,
                                              longitude: 103.848,
                                              zoom: 16)
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.Mapview!.delegate = self
        //       self.view = Mapview // To Show only on main view
        //        makeButton()
        
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 80.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    
    
    //    MARK: - @IBAction
    
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func UsethislocationTapped(_ sender: UIButton) {
        
        self.callback?(self.lblcurrentLocation.text!, latitude, longitude)
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    //    @objc func autocompleteClicked(_ sender: UIButton) {
    //        let autocompleteController = GMSAutocompleteViewController()
    //        autocompleteController.delegate = self
    //
    //        // Specify the place data types to return.
    //        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
    //                                                  UInt(GMSPlaceField.placeID.rawValue))
    //        autocompleteController.placeFields = fields
    //
    //        // Specify a filter.
    //        let filter = GMSAutocompleteFilter()
    //        //          filter.type = [.address]
    //        autocompleteController.autocompleteFilter = filter
    //
    //        // Display the autocomplete view controller.
    //        present(autocompleteController, animated: true, completion: nil)
    //    }
    
    // Add a button to the view.
    //    func makeButton() {
    //        let btnLaunchAc = UIButton(frame: CGRect(x: 5, y: 150, width: 300, height: 35))
    //        btnLaunchAc.backgroundColor = .blue
    //        btnLaunchAc.setTitle("Launch autocomplete", for: .normal)
    //        btnLaunchAc.addTarget(self, action: #selector(autocompleteClicked), for: .touchUpInside)
    //        self.view.addSubview(btnLaunchAc)
    //    }
    
}



// MARK: - Delegate

extension CurrentLocationVC: CLLocationManagerDelegate,GMSMapViewDelegate,GMSAutocompleteResultsViewControllerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        Mapview.isMyLocationEnabled = true
        Mapview.settings.myLocationButton = true
        Mapview.padding = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 5)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        Mapview.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
        
        // 8
        locationManager.stopUpdatingLocation()
        
        // print current location
        let userLocation = locations.last
        
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 16);
        self.Mapview.camera = camera
        
        let marker = GMSMarker(position: center)
        
        print("Current_Latitude  :  \(userLocation!.coordinate.latitude)")
        print("Current_Longitude : \(userLocation!.coordinate.longitude)")
        marker.map = self.Mapview
        
        self.latitude = Double(userLocation!.coordinate.latitude)
        self.longitude = Double(userLocation!.coordinate.longitude)
        
        marker.title = "Current Location"
        locationManager.stopUpdatingLocation()
        self.latLong(lat: Double(userLocation!.coordinate.latitude), long: Double(userLocation!.coordinate.longitude))
    }
    
    
    func latLong(lat: Double,long: Double)  { // Get Current address from lat and long
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { [self] (placemarks, error) -> Void in
            
            print("Response GeoLocation : \(placemarks)")
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Street address
            if let thoroughfare = placeMark?.addressDictionary!["Thoroughfare"] as? NSString {
                self.Currentaddress.append(thoroughfare as String)
                self.Currentaddress.append(", ")
                print("Thoroughfare Ritesh :- \(thoroughfare)")
            }
            
            // Location name
            if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                self.Currentaddress.append(locationName as String)
                self.Currentaddress.append(", ")
                print("Location Name Ritesh:- \(locationName)")
            }
            
            // ZIP
            if let zip = placeMark.addressDictionary!["ZIP"] as? String{
                self.Currentaddress.append(zip as String)
                self.Currentaddress.append(", ")
                print("ZIP  Ritesh:- \(zip)")
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? String {
                self.Currentaddress.append(city as String)
                self.Currentaddress.append(", ")
                print("City Ritesh:- \(city)")
            }
            
            // State
            if let state = placeMark.addressDictionary!["State"] as? String{
                self.Currentaddress.append(state as String)
                self.Currentaddress.append(", ")
                print("State Ritesh:- \(state)")
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? String {
                self.Currentaddress.append(country as String)
                self.Currentaddress.append(" ")
                print("Country Ritesh:- \(country)")
            }
            
            self.lblcurrentLocation.text = String.getString(self.Currentaddress)
            
            
        })
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        self.latitude = Double(coordinate.latitude)
        self.longitude = Double(coordinate.longitude)
        
        //Creating Marker
        let marker = GMSMarker(position: coordinate)
        
        let decoder = CLGeocoder()
        
        //This method is used to get location details from coordinates
        decoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, err in
            if let placeMark = placemarks?.first {
                
                let placeName = placeMark.name ?? placeMark.subThoroughfare ?? placeMark.thoroughfare!   ///Title of Marker
                //Formatting for Marker Snippet/Subtitle
                //                var address : String! = ""
                
                if let fstreet = placeMark.name  {
                    self.street = fstreet
                    //                    self.Currentaddress.append(fstreet)
                    //                    self.Currentaddress.append(", ")
                    print("fstreet=-=-=\(fstreet)")
                    
                }
                if let subLocality = placeMark.subLocality ?? placeMark.name {
                    self.subLocality = subLocality
                    
                    //                    self.Currentaddress.append(subLocality)
                    //                    self.Currentaddress.append(", ")
                    print("sublocality=-=-=-\(subLocality)")
                }
                if let city = placeMark.locality ?? placeMark.subAdministrativeArea {
                    self.city = city
                    //                    self.Currentaddress.append(city)
                    //                    self.Currentaddress.append(", ")
                    print("City=-=-=-\(city)")
                }
                if let state = placeMark.administrativeArea, let country = placeMark.country {
                    self.state = state
                    self.country = country
                    //                    self.Currentaddress.append(state)
                    //                    self.Currentaddress.append(", ")
                    //                    self.Currentaddress.append(country)
                    print("country=-=-=-\(state),\(country)")
                }
                
                // Adding Marker Details
                marker.title = placeName
                marker.snippet =  self.Currentaddress
                marker.appearAnimation = .pop
                marker.map = mapView
                
                
                self.lblcurrentLocation.text = "\(self.street),\(self.subLocality),\(self.city),\(self.state),\(self.country)"
            }
        }
    }
    
    
    //    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
    //  If you want to press long then use this function
    //    }
    
    
    
    // Handle the user's selection.
    //    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    //        print("Place name: \(place.name)")
    //        print("Place ID: \(place.placeID)")
    //        print("Place attributions: \(place.attributions)")
    //        dismiss(animated: true, completion: nil)
    //    }
    //
    //    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    //        // TODO: handle the error.
    //        print("Error: ", error.localizedDescription)
    //    }
    //
    //    // User canceled the operation.
    //    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    //        dismiss(animated: true, completion: nil)
    //    }
    //
    //    // Turn the network activity indicator on and off again.
    //    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    //    }
    //
    //    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    //        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    //    }
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

