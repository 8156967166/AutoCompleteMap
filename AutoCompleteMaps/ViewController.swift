//
//  ViewController.swift
//  AutoCompleteMaps
//  Created by Aneesha on 19/05/24.

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap {
    
    @IBOutlet weak var googleMapsContainer: UIView!
    
    var googleMapsView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.googleMapsView = GMSMapView(frame: self.googleMapsContainer.frame)
        self.view.addSubview(googleMapsView)
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async {
            let position = CLLocationCoordinate2DMake(lat, lon)
            let maker = GMSMarker(position: position)
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.googleMapsView.camera = camera
            maker.title = "Address : \(title)"
            maker.map = self.googleMapsView
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let token = GMSAutocompleteSessionToken.init()

        let filter = GMSAutocompleteFilter()
        filter.type = .establishment // or other types like .region, .geocode, etc.

        let placeClient = GMSPlacesClient.shared()
        
        placeClient.findAutocompletePredictions(fromQuery: "query", filter: filter, sessionToken: token) { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error.localizedDescription)")
                return
            }
            
            if let results = results {
                for result in results {
                    print("Result: \(result.attributedFullText.string)")
                    if let rslt = result as? GMSAutocompletePrediction {
                        self.resultArray.append(rslt.attributedFullText.string)
                    }
                }
                
                self.searchResultController.reloadDataWithArray(self.resultArray)
            }
        }
    }
    

    @IBAction func SearchWithAddress(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
}

