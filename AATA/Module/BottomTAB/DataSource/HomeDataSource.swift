//
//  HomeDataSource.swift
//  AATA
//
//  Created by Uday Patel on 25/10/21.
//

import UIKit

protocol HomeDelegate: class {
    ///
    func didSelect(_ index: Int, category: String)
    ///
    func selectedDeviceId(_ deviceId: String)
    ///
    func openDateRange()
}

///
class HomeDataSource: NSObject {
    // MARK: - Variable
    ///
    private var cellIdentifier1 = "HomeCell"
    ///
    private var cellIdentifier2 = "WeatherCell"
    ///
    private var graphCell: HomeCell?
    ///
    var tableView: UITableView!
    ///
    var delegate: HomeDelegate?
    ///
    var devicedelegate : DeviceDelegate?
    ///
    var endDeviceList: [EndDevice] = []
    ///
    var timeSeries: [TimeSeries] = []
    ///
    var selectedCategory: Int = 0
    ///
    var selectedEndDeviceId: String = ""
    ///
    var selectedWeatherCategory: Weather = .soilMoisture
    ///
    var wList: [[String: Any]] = []
    ///
    var weatherDataList: WeatherData? {
        didSet {
            if let weatherDataList = self.weatherDataList {
                wList = getAverageWeatherDataList(weatherDataList)
                tableView.reloadData()
            }
        }
    }
    
    ///
    func getFromattedDate(_ dateString: String) -> String {
        let dateStringObject = dateString
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from:dateStringObject)!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    ///
    func getAverageWeatherDataList(_ weatherDataList: WeatherData) -> [[String: Any]] {
        var storedDate = ""
        var count = 0
        
        var list: [[String: Any]] = []
        
        var noaaList: [Double] = []
        var sgList: [Double] = []
        
        var min_noaa = 0.0
        var min_sg = 0.0
        var max_noaa = 0.0
        var max_sg = 0.0
        
        switch selectedWeatherCategory {
        case .soilMoisture:
            for (index, item) in weatherDataList.soilMoisture.enumerated() {
                let currentDateString = getFromattedDate(item.time)
                
                if weatherDataList.soilMoisture.count - 1 == index {
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                } else if storedDate == currentDateString || storedDate == "" {
                    count += 1
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    storedDate = currentDateString
                } else if storedDate != currentDateString && storedDate != "" {
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                    // Reset Values
                    noaaList = []
                    sgList = []
                    // Reinitialised Values
                    count = 1
                    storedDate = currentDateString
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                }
            }
        case .temperature:
            for (index, item) in weatherDataList.airTemperature.enumerated() {
                let currentDateString = getFromattedDate(item.time)
                
                if weatherDataList.airTemperature.count - 1 == index {
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                } else if storedDate == currentDateString || storedDate == "" {
                    count += 1
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    storedDate = currentDateString
                } else if storedDate != currentDateString && storedDate != "" {
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                    // Reset Values
                    noaaList = []
                    sgList = []
                    // Reinitialised Values
                    count = 1
                    storedDate = currentDateString
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                }
            }
        case .precipitation:
            for (index, item) in weatherDataList.precipitation.enumerated() {
                let currentDateString = getFromattedDate(item.time)
                
                if weatherDataList.precipitation.count - 1 == index {
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                } else if storedDate == currentDateString || storedDate == "" {
                    count += 1
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    storedDate = currentDateString
                } else if storedDate != currentDateString && storedDate != "" {
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                    // Reset Values
                    noaaList = []
                    sgList = []
                    // Reinitialised Values
                    count = 1
                    storedDate = currentDateString
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                }
            }
        case .wind:
            for (index, item) in weatherDataList.windSpeed.enumerated() {
                let currentDateString = getFromattedDate(item.time)
                
                if weatherDataList.windSpeed.count - 1 == index {
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                } else if storedDate == currentDateString || storedDate == "" {
                    count += 1
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                    storedDate = currentDateString
                } else if storedDate != currentDateString && storedDate != "" {
                    // Get Min & Max Data
                    min_noaa = noaaList.min() ?? 0.0
                    min_sg = sgList.min() ?? 0.0
                    max_noaa = noaaList.max() ?? 0.0
                    max_sg = sgList.max() ?? 0.0
                    // Create Array Object
                    list.append([
                        "min_noaa": min_noaa,
                        "min_sg": min_sg,
                        "max_noaa": max_noaa,
                        "max_sg": max_sg,
                        "time": storedDate
                    ])
                    // Reset Values
                    noaaList = []
                    sgList = []
                    // Reinitialised Values
                    count = 1
                    storedDate = currentDateString
                    noaaList.append(item.noaa)
                    sgList.append(item.sg)
                }
            }
        case .voltageDetector:
            break
        }
        print("list", list)
        return list
    }
    
    // MARK: - Initializer
    /// Initialize class with tableView
    ///
    /// - Parameter tableview: object of UITableView
    convenience init(withTableView tableview: UITableView) {
        self.init()
        self.tableView = tableview
        tableview.register(UINib.init(nibName: cellIdentifier1, bundle: nil), forCellReuseIdentifier: cellIdentifier1)
        tableview.register(UINib.init(nibName: cellIdentifier2, bundle: nil), forCellReuseIdentifier: cellIdentifier2)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = .clear
        /*tableview.separatorStyle = .none*/
        tableview.estimatedRowHeight = 200
        tableview.rowHeight = UITableView.automaticDimension
        tableview.tableFooterView = UIView()
        tableview.tableHeaderView?.removeFromSuperview()
        tableview.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableview.layoutIfNeeded()
    }
    
    ///
    func getCellForTableView(index: Int) -> HomeCell {
        let bundelName = cellIdentifier1
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? HomeCell else { return HomeCell() }
        return cell
    }
    
    ///
    func getCellForTableView(index: Int) -> WeatherCell {
        let bundelName = cellIdentifier2
        let arrnNib = Bundle.main.loadNibNamed(bundelName, owner: self, options: nil)
        guard let cell = arrnNib?[index] as? WeatherCell else { return WeatherCell() }
        return cell
    }
    
    ///
    @objc func openDateRange(_ sender: UIButton) {
        delegate?.openDateRange()
    }
}

extension HomeDataSource: UITableViewDelegate, UITableViewDataSource {
    ///
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : CGFloat.leastNormalMagnitude
    }
    
    ///
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 183/255, green: 183/255, blue: 183/255, alpha: 0.2)
        return view
    }
    
    ///
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return endDeviceList.count > 0 ? 1 : 0
        case 2: return 1
        case 3: return wList.count > 0 ? wList.count : 1
        default: return 0
        }
    }
    
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: HomeCell = graphCell ?? getCellForTableView(index: 2)
            if graphCell == nil {
                graphCell = cell
            }
            cell.delegate = delegate
            cell.deviceLabel.text = "  " + selectedEndDeviceId
            cell.timeSeries = timeSeries
            cell.endDeviceList = endDeviceList
            cell.filterButton.addTarget(self, action: #selector(openDateRange(_:)), for: .touchUpInside)
            cell.configureChart()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell: HomeCell = getCellForTableView(index: 0)
            cell.dataSource1?.endDeviceList = endDeviceList
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell: HomeCell = getCellForTableView(index: 1)
            cell.dataSource2?.delegate = self
            cell.dataSource2?.selectedIndex = selectedCategory
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case 3:
            if wList.count > 0 {
                let cell: WeatherCell = getCellForTableView(index: 0)
                switch selectedWeatherCategory {
                case .soilMoisture:
                    cell.configuredSoilMoistureData(wList[indexPath.row])
                case .temperature:
                    cell.configureTemperatureData(wList[indexPath.row])
                case .precipitation:
                    cell.configuredPrecipitationData(wList[indexPath.row])
                case .wind:
                    cell.configuredWindData(wList[indexPath.row])
                case .voltageDetector:
                    break
                }
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
            } else {
                let cell: WeatherCell = getCellForTableView(index: 1)
                cell.dataNotAvialableLabel.text = R.string.localizable.noRecordFound()
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
            }
        default: break
        }
        return UITableViewCell()
    }
    
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0: break
        case 1: break
        case 2: break
        case 3: break
        default: break
        }
    }
    
    ///
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    ///
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            guard let header = Bundle.main.loadNibNamed("CommonHeader", owner: self, options: nil)?[0] as? CommonHeader else {
                return nil
            }
            header.deviceTitleLabel.text = "Devices"
            header.backgroundColor = .clear
            return endDeviceList.count > 0 ? header : nil
        default: return nil
        }
    }
    
    ///
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1: return endDeviceList.count > 0 ? 50 : CGFloat.leastNormalMagnitude
        default: return CGFloat.leastNormalMagnitude
        }
    }
    
    ///
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    ///
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) { }
    }
}

///
extension HomeDataSource: DeviceCategoryDelegate {
    ///
    func didSelect(_ index: Int, category: String) {
        print(index, category)
        selectedCategory = index
        selectedWeatherCategory = Weather.init(rawValue: category) ?? .soilMoisture
        tableView.reloadSections([1], with: .none)
        delegate?.didSelect(index, category: category)
    }
}
