//
//  HomeVC.swift
//  AATA
//
//  Created by Uday Patel on 21/09/21.
//

import UIKit
import AWSMobileClient
import SideMenuSwift
import PINCache
import SwiftyJSON

///
class HomeVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var homeDeviceTable: UITableView!
    ///
    @IBOutlet weak var notesButton: UIButton!
    
    // MARK: - Variables
    ///
    var viewModal: HomeViewModal = HomeViewModal()
    ///
    var dataSource: HomeDataSource?
    ///
    var startDate: Date = Date()
    var toDate: Date = Date()
    ///
    var endDeviceId: String = ""
    ///
    let group = DispatchGroup()
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesButton.isHidden = SharedDataManager.shared.userGroupName == UserGroupName.mobileUser.rawValue
        let currentDate = Date()
        toDate = currentDate
        var components = DateComponents()
        components.setValue(-1, for: .day)
        startDate = Calendar.current.date(byAdding: components, to: currentDate) ?? currentDate
        
        DateRangeSelection.shared.selectedStartDate = startDate
        DateRangeSelection.shared.startDateLabel.text = startDate.dateToGraphString()
        DateRangeSelection.shared.selectedEndDate = toDate
        DateRangeSelection.shared.endDateLabel.text = toDate.dateToGraphString()
        
        setupUI()
        setupDataSource()
    }
    
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helper Methods
    ///
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
            strongSelf.getWeatherData(.soilMoisture)
            CommonMethods.showProgressHud(inView: strongSelf.view)
            strongSelf.getEndDeviceAPI()
            strongSelf.group.notify(queue: .main) {
                CommonMethods.hideProgressHud()
            }
        }
    }
    
    ///
    func setupDataSource() {
        dataSource = HomeDataSource.init(withTableView: homeDeviceTable)
        dataSource?.delegate = self
    }
    
    ///
    func reloadTimeSeries(_ timeSeries: [TimeSeries]) {
        dataSource?.timeSeries = timeSeries
        homeDeviceTable.reloadData()
    }
    
    ///
    func reloadEndDeviceDataSource(_ endDeviceList: [EndDevice]) {
        guard dataSource != nil else { return }
        dataSource?.endDeviceList = endDeviceList
        homeDeviceTable.reloadData()
    }
    
    ///
    func reloadWeatherDataSource(_ weatherDataList: WeatherData) {
        guard dataSource != nil else { return }
        dataSource?.weatherDataList = weatherDataList
        homeDeviceTable.reloadData()
    }
    
    ///
    func reloadEndDeviceId() {
        guard dataSource != nil else { return }
        dataSource?.selectedEndDeviceId = self.endDeviceId
        homeDeviceTable.reloadData()
    }
    
    ///
    func getWeatherData(_ weather: Weather) {
        var queryPoint = ""
        var queryString = ""
        var isHaveWeatherData = false
        switch weather {
        case .soilMoisture:
            queryPoint = "bio/point?"
            queryString = "soilMoisture"
            if Constants.soilMoistureWeatherList != nil {
                isHaveWeatherData = true
            }
        case .temperature:
            queryPoint = "weather/point?"
            queryString = "airTemperature"
            if Constants.temperatureWeatherList != nil {
                isHaveWeatherData = true
            }
        case .precipitation:
            queryPoint = "weather/point?"
            queryString = "precipitation"
            if Constants.precipitationWeatherList != nil {
                isHaveWeatherData = true
            }
        case .wind:
            queryPoint = "weather/point?"
            queryString = "windSpeed"
            if Constants.windWeatherList != nil {
                isHaveWeatherData = true
            }
        case .voltageDetector:
            queryPoint = ""
            queryString = ""
        }
        if let latitude = LocationManager.shared.userLocation?.coordinate.latitude, let longitude = LocationManager.shared.userLocation?.coordinate.longitude, queryString.trim().count != 0, !isHaveWeatherData {
            group.enter()
            
            viewModal.getWeatherData(queryPoint, "\(latitude)", "\(longitude)", queryString) { [weak self] (response, isSuccess) in
                self?.group.leave()
                guard isSuccess else {
                    return
                }
                self?.setWeatherData(weather, response)
                self?.reloadWeatherDataSource(response)
            }            
        } else {
            reloadWithExistingWeatherData(weather)
        }
    }
    
    ///
    func getTimeSeries(deviceID: String, startDate: Date, toDate: Date) {
        group.enter()
        APIServices.shared.getChartDataAPI(deviceID, startDate.dateToString("yyyy-MM-dd"), toDate.dateToString("yyyy-MM-dd"), { [weak self] (response, isSuccess) in
            self?.group.leave()
            guard isSuccess else { return }
            let filterforTime = response.filter { timeSeries in
                let timeStamp = timeSeries.timestamp.convertDateStringToDate(currentDateFormatter: "yyyy-MM-dd HH:mm:ss.SSSS")
                return timeStamp >= startDate && timeStamp <= toDate
            }
            self?.reloadTimeSeries(filterforTime)
        })
    }
    
    ///
    func getEndDeviceAPI() {
        guard let propertyId = Constants.selectedProperty?.id else { return }
        let propertyIdString: String =  "\(propertyId)"
        group.enter()
        
        viewModal.getEndDeviceAPI(propertyId: propertyIdString) { [weak self] (response, isSuccess) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.group.leave()
            guard isSuccess else { return }
            print("realdata")
            let treeSensorDevices = response.filter { $0.endDeviceType == "tree_tilt_sensor" }
            strongSelf.reloadEndDeviceDataSource(treeSensorDevices)
            if response.count > 0 {
                strongSelf.endDeviceId = response.first?.deviceId ?? ""
                strongSelf.getTimeSeries(deviceID: response.first?.deviceId ?? "", startDate: strongSelf.startDate, toDate: strongSelf.toDate)
                strongSelf.reloadEndDeviceId()
            }
        }
        
        
    }
    
    ///
    func setWeatherData(_ weather: Weather, _ response: WeatherData) {
        switch weather {
        case .soilMoisture:
            Constants.soilMoistureWeatherList = response
        case .temperature:
            Constants.temperatureWeatherList = response
        case .precipitation:
            Constants.precipitationWeatherList = response
        case .wind:
            Constants.windWeatherList = response
        case .voltageDetector:
            break
        }
    }
    
    ///
    func reloadWithExistingWeatherData(_ weather: Weather) {
        switch weather {
        case .soilMoisture:
            if let data = Constants.soilMoistureWeatherList {
                reloadWeatherDataSource(data)
            }
        case .temperature:
            if let data = Constants.temperatureWeatherList {
                reloadWeatherDataSource(data)
            }
        case .precipitation:
            if let data = Constants.precipitationWeatherList {
                reloadWeatherDataSource(data)
            }
        case .wind:
            if let data = Constants.windWeatherList {
                reloadWeatherDataSource(data)
            }
        case .voltageDetector:
            break
        }
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onMyNoteTap(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        guard let vc = R.storyboard.common.myNotesVC() else { return }
        navigationController.pushViewController(vc, animated: true)
    }
    
    ///
    @IBAction func onNotificationTap(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        guard let vc = R.storyboard.common.notificationListVC() else { return }
        navigationController.pushViewController(vc, animated: true)
    }
    
    ///
    @IBAction func sideMenuTapped(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    ///
    
    
}

///
extension HomeVC: HomeDelegate {
    ///
    func openDateRange() {
        DateRangeSelection.shared.setupDateRangePopup { (startDate, toDate)  in
            self.startDate = startDate
            self.toDate = toDate
            self.getTimeSeries(deviceID: self.endDeviceId, startDate: self.startDate, toDate: self.toDate)
        }
    }
    
    ///
    func didSelect(_ index: Int, category: String) {
        getWeatherData(Weather.init(rawValue: category) ?? .soilMoisture)
    }
    
    ///
    func selectedDeviceId(_ deviceId: String) {
        self.endDeviceId = deviceId
        reloadEndDeviceId()
        self.getTimeSeries(deviceID: self.endDeviceId, startDate: self.startDate, toDate: self.toDate)
    }
}

