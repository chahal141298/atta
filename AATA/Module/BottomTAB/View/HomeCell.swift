//
//  HomeCell.swift
//  AATA
//
//  Created by Uday Patel on 25/10/21.
//

import UIKit
import Charts
import DropDown

///
class HomeCell: UITableViewCell {
   
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var lineChart: LineChartView!
    ///
    @IBOutlet weak var deviceCollectionView: UICollectionView!
    ///
    @IBOutlet weak var weatherCategoryCollectionView: UICollectionView!
    ///
    @IBOutlet weak var deviceDropDownButton: UIButton!
    ///
    @IBOutlet weak var filterButton: UIButton!
    ///
    @IBOutlet weak var deviceLabel: UILabel!
    
    // MARK: - Variable
    ///
    var deviceViewModal: DeviceViewModel = DeviceViewModel()
    ///
    var dataSource1: DeviceHomeDataSource?
    ///
    var dataSource2: DeviceCategoryDataSource?
    ///
    var timeSeries: [TimeSeries] = []
    ///
    let deviceDropDown = DropDown()
    ///
    var delegate: HomeDelegate?
    ///
    var endDeviceList: [EndDevice] = []
    
    ///
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if deviceCollectionView != nil {
            dataSource1 = DeviceHomeDataSource.init(deviceCollectionView)
            dataSource1?.delegate = self
        }
        if weatherCategoryCollectionView != nil {
            dataSource2 = DeviceCategoryDataSource.init(weatherCategoryCollectionView)
        }
        if deviceDropDownButton != nil {
            setupDropDown()
        }
    }
    
    ///
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    ///
    @IBAction func onDeviceTap(_ sender: Any) {
        reloadZoneDropDown(deviceList: endDeviceList)
    }
    
    ///
    func setupDropDown() {
        let arrDropDown: [DropDown] = [deviceDropDown]
        arrDropDown.forEach { $0.direction = .any }
        arrDropDown.forEach {
            $0.backgroundColor = UIColor.white
            $0.layer.cornerRadius = 5.0
            $0.clipsToBounds = true
        }
        configureAddressDropdown()
    }
    
    ///
    func configureAddressDropdown() {
        deviceDropDown.direction = .any
        deviceDropDown.anchorView = deviceDropDownButton
        deviceDropDown.width = deviceDropDownButton.frame.width
        deviceDropDown.bottomOffset = CGPoint(x: 0, y: deviceDropDownButton.bounds.height)
        deviceDropDown.selectionAction = { [unowned self] (index, item) in
            self.deviceLabel.text = item.trim() != "Select Device" ? "  " + item : "  " + "Select Device"
            self.deviceLabel.textColor = item.trim() != "Select Device" ? .black : .lightGray
            if item.trim() != "Select Device" && self.delegate != nil{
                self.delegate?.selectedDeviceId(item.trim())
            }
        }
    }
    
    ///
    func reloadZoneDropDown(deviceList: [EndDevice]) {
        var list: [String] = []
        list.append(contentsOf: deviceList.map { $0.deviceId })
        deviceDropDown.dataSource = list
        deviceDropDown.show()
    }
    
    ///
    func configureChart() {
        // lineChart.delegate = self
        // lineChart.chartDescription.enabled = false
        guard lineChart != nil else { return }
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(true)
        lineChart.pinchZoomEnabled = true
        
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        // llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .bottomRight
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        // lineChart.xAxis.gridLineDashLengths = [10, 10]
        // lineChart.xAxis.gridLineDashPhase = 0
        
        // let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
        // ll1.lineWidth = 4
        // ll1.lineDashLengths = [5, 5]
        // ll1.labelPosition = .topRight
        // ll1.valueFont = .systemFont(ofSize: 10)
        //
        // let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
        // ll2.lineWidth = 4
        // ll2.lineDashLengths = [5,5]
        // ll2.labelPosition = .bottomRight
        // ll2.valueFont = .systemFont(ofSize: 10)
        var xList: [String] = []
        for date in self.timeSeries {
            let dateString = date.timestamp.convertDate(currentDateFormatter: "yyyy-MM-dd HH:mm:ss.SSSS", requiredDateFormatter: "MM/dd,HH:mm")
            xList.append(dateString)
        }
        let xAxis = lineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 4 // 3
        xAxis.valueFormatter = IndexAxisValueFormatter.init(values: xList)
        
        let leftAxis = lineChart.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.granularity = 45
        leftAxis.labelCount = 5
        // leftAxis.addLimitLine(ll1)
        // leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = 90
        leftAxis.axisMinimum = -90
        // leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        lineChart.rightAxis.enabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.labelPosition = .bottom
        //[_lineChart.viewPortHandler setMaximumScaleY: 2.f];
        //[_lineChart.viewPortHandler setMaximumScaleX: 2.f];
        
        // let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
        //       font: .systemFont(ofSize: 12),
        //       textColor: .white,
        //       insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        // marker.lineChart = lineChart
        // marker.minimumSize = CGSize(width: 80, height: 40)
        // lineChart.marker = marker
        
        let customMarker = CustomMakerView(frame: CGRect(x: 0, y: 0, width: 200, height: 80), timeSeries: self.timeSeries)
         lineChart.marker = customMarker
        customMarker.chartView = lineChart
        
        lineChart.legend.form = .line
        // lineChart.legend.enabled = false
        
        // sliderX.value = 45
        // sliderY.value = 100
        // slidersValueChanged(nil)
        
        lineChart.animate(xAxisDuration: 1.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.setDataCount(self.timeSeries.count)
        }
    }
    
    ///
    func setDataCount(_ count: Int) {
        let values1 = (0..<count).map { (i) -> ChartDataEntry in
            let val = self.timeSeries[i].realZ
            return ChartDataEntry(x: Double(i), y: Double(val))
        }
        
        let values2 = (0..<count).map { (i) -> ChartDataEntry in
            let val = self.timeSeries[i].realY
            return ChartDataEntry(x: Double(i), y: Double(val))
        }
        // 1
        let set1 = LineChartDataSet(entries: values1, label: "")
        set1.drawIconsEnabled = false
        // set1.drawVerticalHighlightIndicatorEnabled = false
        // set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.drawValuesEnabled = true
        setup(set1)
        // let value = ChartDataEntry(x: Double(3), y: 3)
        // set1.addEntryOrdered(value)
        // let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor, ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        // let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        set1.fillAlpha = 1
        set1.setColor(UIColor.init(named: "clr_light_bg") ?? .black)
        set1.setCircleColor(UIColor.init(named: "clr_light_bg") ?? .black)
        set1.label = "Z: Forward/Backward"
        // set1.fill = LinearGradientFill(gradient: gradient, angle: 90)
        // set1.drawFilledEnabled = true
        // 2
        let set2 = LineChartDataSet(entries: values2, label: "")
        set2.drawIconsEnabled = false
        set2.drawValuesEnabled = true
        setup(set2)
        set2.fillAlpha = 1
        set2.setColor(UIColor.init(named: "clr_dark_bg") ?? .blue)
        set2.setCircleColor(UIColor.init(named: "clr_dark_bg") ?? .blue)
        set2.label = "Y: Sidewise"
        
        let data = LineChartData(dataSets: [set1, set2])
        lineChart.data = data
    }
    
    private func setup(_ dataSet: LineChartDataSet) {
        // if dataSet.isDrawLineWithGradientEnabled {
        //     dataSet.lineDashLengths = nil
        //     dataSet.highlightLineDashLengths = nil
        //     dataSet.setColors(.black, .red, .white)
        //     dataSet.setCircleColor(.black)
        //     dataSet.gradientPositions = [0, 40, 100]
        //     dataSet.lineWidth = 1
        //     dataSet.circleRadius = 3
        //     dataSet.drawCircleHoleEnabled = false
        //     dataSet.valueFont = .systemFont(ofSize: 9)
        //     dataSet.formLineDashLengths = nil
        //     dataSet.formLineWidth = 1
        //     dataSet.formSize = 15
        // } else {
        // dataSet.lineDashLengths = [5, 2.5]
        // dataSet.highlightLineDashLengths = [5, 2.5]
        // dataSet.setColor(UIColor.init(named: "clr_light_bg") ?? .black)
        // dataSet.gradientPositions = nil
        dataSet.lineWidth = 1
        dataSet.circleRadius = 5
        dataSet.drawCircleHoleEnabled = true
        dataSet.valueFont = .systemFont(ofSize: 9)
        // dataSet.formLineDashLengths = [5, 2.5]
        dataSet.formLineWidth = 1
        dataSet.formSize = 15
        dataSet.drawValuesEnabled = false
        dataSet.mode = .linear
        // dataSet.highlightEnabled = true
    }

    
    func navigateToDeviceTree(_ deviceDetail: EndDeviceDetail?) {
        guard let vc = R.storyboard.deviceTree.deviceTreeVC() else { return }
        vc.deviceDetail = deviceDetail
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeCell: DeviceDelegate {
    
    func reloadApi() {
        
    }
    
    ///
    func didSelect(id: String, deviceId: String) {
        CommonMethods.showProgressHud(inView: (parentViewController?.view)!)
        deviceViewModal.getEndDeviceDetailAPI(endDeviceId: id) { (endDevice, isSuccess) in
            CommonMethods.hideProgressHud()
            guard isSuccess else { return }
            self.navigateToDeviceTree(endDevice)
        }
    }
    
}
