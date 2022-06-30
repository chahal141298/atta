//
//  HomeViewModal.swift
//  AATA
//
//  Created by Uday Patel on 13/11/21.
//
import UIKit
import SwiftyJSON

///
class HomeViewModal: NSObject {
    ///
    func getWeatherData(_ queryPoint:String,_ lat: String, _ long: String, _ queryString: String, _ completion: @escaping(WeatherData, Bool) -> Void) {
        let endDate = NSDate()
        let endUnixtime = endDate.timeIntervalSince1970
        let startDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
        let startUnixtime = (startDate ?? Date()).timeIntervalSince1970
        APIServices.shared.getWeatherData(queryPoint + "lat=\(lat)" + "&" + "lng=\(long)" + "&" + "params=\(queryString)" + "&" + "start=\(startUnixtime)" + "&" + "end=\(endUnixtime)") { (response, isSuccess) in
            completion(WeatherData.init(JSON(response)), isSuccess)
        }
    }
    
    ///
    func getEndDeviceAPI(propertyId: String, _ completion: @escaping([EndDevice], Bool) -> Void) {
        APIServices.shared.getEndDeviceAPI(propertyId: propertyId) { (response, isSuccess) in
            completion(response, isSuccess)
        }
    }
}
