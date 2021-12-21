//
//  ViewController.swift
//  MapViewAssessment
//
//  Created by bhagya on 20/12/21.
//

import UIKit
import MapKit
import PopupDialog


class ViewController: UIViewController ,UISearchBarDelegate{
    let location = [["titel":"Mumbai","latitude":19.0760,"longitude":72.8777 ],["titel":"hydrabad","latitude":17.3850,"longitude":78.4867 ],["titel":"Bengaluru","latitude":12.9716,"longitude":77.5946 ]]

    @IBOutlet weak var searchbtn: UIBarButtonItem!
    @IBOutlet weak var myMapView: MKMapView!
    let userdefalut = UserDefaults()
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        displayMultipleLocation()
        retriveDataUser()
    }
}
//MARK: Essential functions
extension ViewController{
    //Function for popup
    func showPopUp(_ message:String,_ tittle:String){
        let popUpDlg = PopupDialog(title: tittle, message: message)
        self.present(popUpDlg, animated: true, completion: nil)
    }
    //Function for retriving data from user
    func retriveDataUser(){
        let key = "bhagya"
        let locationdictionary = userdefalut.object(forKey: key) as? Dictionary<String,NSNumber>
        let locationlat = locationdictionary?["lat"]?.doubleValue
        let locationlon = locationdictionary?["lon"]?.doubleValue
        let anotaion = MKPointAnnotation()
        anotaion.coordinate = CLLocationCoordinate2D(latitude: locationlat ?? 12.9716 , longitude: locationlon ?? 77.5946)
        self.myMapView.addAnnotation(anotaion)
    }
    //Function for click action on search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activesearch = MKLocalSearch(request: searchRequest)
        activesearch.start{ [self]
            (respond ,error) in
            activityIndicator.stopAnimating()
            if respond == nil{
                showPopUp( "No city found as per your input","Oops..Sorry")
            }
            else{
                let lattitude = respond!.boundingRegion.center.latitude
                let longitude = respond!.boundingRegion.center.longitude
                self.userdefalut.set(["lat":lattitude,"lon":longitude],forKey: "bhagya")
                let anotaion = MKPointAnnotation()
                anotaion.title = searchBar.text
                anotaion.coordinate = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                self.myMapView.addAnnotation(anotaion)
            }
        }
    }
    //Function for dummy locations, userdefaults.
    func displayMultipleLocation(){
        for location in location{
            let anotation = MKPointAnnotation()
            anotation.title = location["titel"] as? String
            let loc = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
            anotation.coordinate = loc
            myMapView.addAnnotation(anotation)
        }
    }
}

