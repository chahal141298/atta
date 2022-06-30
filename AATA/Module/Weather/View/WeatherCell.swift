//
//  WeatherCell.swift
//  AATA
//
//  Created by Uday Patel on 30/09/21.
//

import UIKit

class WeatherCell: UITableViewCell {
    ///
    @IBOutlet weak var titleLabel1: UILabel!
    ///
    @IBOutlet weak var titleLabel2: UILabel!
    ///
    @IBOutlet weak var valueLabel1: UILabel!
    ///
    @IBOutlet weak var valueLabel2: UILabel!
    ///
    @IBOutlet weak var dateLabel: UILabel!
    ///
    @IBOutlet weak var weatherIcon: UIImageView!
    ///
    @IBOutlet weak var dataNotAvialableLabel: UILabel!
    
    ///
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    ///
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /*
     Soil moisture: Highest
     Temperature; lowest
     Precipitation: highest
     Wind: highest
     */
    
    ///
    func configuredSoilMoistureData(_ data: [String: Any]) {
        titleLabel1.text = "Average Moisture"
        titleLabel2.text = "Current Moisture"
        valueLabel1.text = "\(data["min_sg"] ?? "")-\(data["max_sg"] ?? "")"
        valueLabel2.text = "\(data["max_sg"] ?? "")"
        dateLabel.text = "\(data["time"] ?? "")"
        weatherIcon.image = UIImage.init(named: "ic_drops_green")
    }
    
    ///
    func configureTemperatureData(_ data: [String: Any]) {
        titleLabel1.text = "Average Temperature"
        titleLabel2.text = "Current Temperature"
        valueLabel1.text = "\(data["min_sg"] ?? "")°C-\(data["max_sg"] ?? "")°C"
        valueLabel2.text = "\(data["min_sg"] ?? "")°C"
        dateLabel.text = "\(data["time"] ?? "")"
        weatherIcon.image = UIImage.init(named: "ic_temp_green")
    }
    
    ///
    func configuredPrecipitationData(_ data: [String: Any]) {
        titleLabel1.text = "Average Precipitation"
        titleLabel2.text = "Current Precipitation"
        valueLabel1.text = "\(data["min_sg"] ?? "")%-\(data["max_sg"] ?? "")%"
        valueLabel2.text = "\(data["max_sg"] ?? "")%"
        dateLabel.text = "\(data["time"] ?? "")"
        weatherIcon.image = UIImage.init(named: "ic_weather_green")
    }
    
    ///
    func configuredWindData(_ data: [String: Any]) {
        titleLabel1.text = "Average Wind"
        titleLabel2.text = "Max Wind"
        valueLabel1.text = "\(data["min_sg"] ?? "")mph-\(data["max_sg"] ?? "")mph"
        valueLabel2.text = "\(data["max_sg"] ?? "")mph"
        dateLabel.text = "\(data["time"] ?? "")"
        weatherIcon.image = UIImage.init(named: "ic_wind_green")
    }
}
