

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate, DidChangeApiDataModelProtocol, CLLocationManagerDelegate  {
    
    @IBOutlet weak var intputTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherModel = ApiModel()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModel.delegate = self
        locationManager.delegate = self
        intputTextField.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        intputTextField.endEditing(true)
    }
    
    
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    // this trigger when user click on go button in the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this close the screen keyboard --- and trigger "textFieldDidEndEditing" and textFieldDidEndEditing
        intputTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text{
            weatherModel.apiCallWithCity(city: city)
        }
        intputTextField.text = ""
    }
    
    // this is use to validate a textField
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else{
            return false
        }
    }
    
    
    func liveDateFromApi(_ dataModel: ApiDataModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = dataModel.temperatureString
            self.conditionImageView.image = UIImage(systemName: dataModel.conditionName)
            self.cityLabel.text = dataModel.cityName
        }
    }
    
    
    func errorData(_ error: Error) {
        print(error)
    }
    
    //MARK: - this is for location processing coming from CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation  = locations[0] as CLLocation
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        locationManager.stopUpdatingLocation()
        weatherModel.apiCallWithLanLong(lat: lat, long: long)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

