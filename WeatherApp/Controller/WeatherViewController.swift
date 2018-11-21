//
//  ViewController.swift
//  WeatherApp
//
//  Created by Leandro Oliveira on 2018-11-16.
//  Copyright © 2018 Leandro Oliveira. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast"
    let APP_ID = "1e9a1cf08861c192e8fda3de78c7b81d"
    let UNITS = "metric"
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherCity = WeatherCity()
    var minTemp : [UILabel] = []
    var maxTemp : [UILabel] = []
    var weatherImg : [UIImageView] = []
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var descriptionLB: UILabel!
    @IBOutlet weak var currentTempLB: UILabel!
    @IBOutlet weak var cityLB: UILabel!
    @IBOutlet weak var min0: UILabel!
    @IBOutlet weak var min1: UILabel!
    @IBOutlet weak var min2: UILabel!
    @IBOutlet weak var min3: UILabel!
    @IBOutlet weak var min4: UILabel!
    @IBOutlet weak var min5: UILabel!
    @IBOutlet weak var max0: UILabel!
    @IBOutlet weak var max1: UILabel!
    @IBOutlet weak var max2: UILabel!
    @IBOutlet weak var max3: UILabel!
    @IBOutlet weak var max4: UILabel!
    @IBOutlet weak var max5: UILabel!
    @IBOutlet weak var weatherIcon1: UIImageView!
    @IBOutlet weak var weatherIcon2: UIImageView!
    @IBOutlet weak var weatherIcon3: UIImageView!
    @IBOutlet weak var weatherIcon4: UIImageView!
    @IBOutlet weak var weatherIcon5: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        minTemp.append(min0)
        minTemp.append(min1)
        minTemp.append(min2)
        minTemp.append(min3)
        minTemp.append(min4)
        minTemp.append(min5)
        maxTemp.append(max0)
        maxTemp.append(max1)
        maxTemp.append(max2)
        maxTemp.append(max3)
        maxTemp.append(max4)
        maxTemp.append(max5)
        weatherImg.append(weatherIcon1)
        weatherImg.append(weatherIcon2)
        weatherImg.append(weatherIcon3)
        weatherImg.append(weatherIcon4)
        weatherImg.append(weatherIcon5)
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters:[String:String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("Error \(response.result.error!)")
                self.cityLB.text = "Connection Issues"
            }
        }
    }
    
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON){
        
        weatherCity.forecastArray.removeAll()
        if json["city"]["name"].string != nil {
            weatherCity.city = json["city"]["name"].stringValue
            
            for index in 0...5 {
                let weatherData = WeatherData()
                
                weatherData.description = json["list"][index]["weather"][0]["description"].stringValue
                weatherData.condition = json["list"][index]["weather"][0]["id"].intValue
                weatherData.weatherIconName = weatherData.updateWeatherIcon(condition: weatherData.condition)
                weatherData.currentTemp = Int((json["list"][index]["main"]["temp"]).double!)
                weatherData.minTemp = Int((json["list"][index]["main"]["temp_min"]).double!)
                weatherData.maxTemp = Int((json["list"][index]["main"]["temp_max"]).double!)
                
                weatherCity.forecastArray.append(weatherData)
            }
        }
        else {
            cityLB.text = "Weather Unavailable"
        }
        
        updateUIWithWeatherData()
        
    }
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData(){
        cityLB.text = weatherCity.city
        currentTempLB.text = "\(weatherCity.forecastArray[0].currentTemp)°"
        descriptionLB.text = "\(weatherCity.forecastArray[0].description.capitalized)"
        weatherIcon.image = UIImage(named: weatherCity.forecastArray[0].weatherIconName)
        
        for (index,value) in weatherCity.forecastArray.enumerated() {
            minTemp[index].text = "\(value.minTemp)°"
            maxTemp[index].text = "\(value.maxTemp)°"
            
            if index < 5 {
                weatherImg[index].image = UIImage(named: value.weatherIconName)
            }
            
            
        }
        
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print ("longitude = \(location.coordinate.longitude), latitute = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params:[String:String] = ["lat":latitude, "lon":longitude, "units":UNITS,"appid":APP_ID]
            
            getWeatherData(url:WEATHER_URL,parameters:params)
            
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLB.text = "Location Unavailable"
    }
    
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city:String){
        
        let params : [String : String] = ["q":city,"units":UNITS ,"appid":APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
  
    
}

