//
//  WeatherViewModal.swift
//  AATA
//
//  Created by Uday Patel on 02/11/21.
//

import UIKit
import SwiftyJSON

///
class WeatherViewModal: NSObject {
    ///
    func getWeatherData(_ queryPoint:String,_ lat: String, _ long: String, _ queryString: String, _ completion: @escaping(WeatherData, Bool) -> Void) {
        // weather/point?lat=58.7984&lng=17.8081&params=airTemperature,precipitation,windSpeed
        // bio/point?lat=19.0760&lng=72.8777&params=soilTemperature,soilMoisture

        let endDate = NSDate() // current date
        let endUnixtime = endDate.timeIntervalSince1970
        let startDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
        let startUnixtime = (startDate ?? Date()).timeIntervalSince1970

        APIServices.shared.getWeatherData(queryPoint + "lat=\(lat)" + "&" + "lng=\(long)" + "&" + "params=\(queryString)" + "&" + "start=\(startUnixtime)" + "&" + "end=\(endUnixtime)") { (response, isSuccess) in
            completion(WeatherData.init(JSON(response)), isSuccess)
        }
    }
}
