//
//  AddTreeTiltDeviceVC.swift
//  AATA
//
//  Created by Macbook on 17/03/22.
//

import UIKit
import DropDown
class AddTreeTiltDeviceVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var selectSirenidDropDown: UILabel!
    @IBOutlet weak var selectTreeTypeDrop: UILabel!
    @IBOutlet weak var selectGatewayDropDown: UILabel!
    @IBOutlet weak var selectPropertyDropDown: UILabel!
    @IBOutlet weak var deviceName: FloatingLabelInput!
    @IBOutlet weak var deviceId: FloatingLabelInput!
    @IBOutlet weak var selectProperty: FloatingLabelInput!
    @IBOutlet weak var selectGateway: FloatingLabelInput!
    @IBOutlet weak var treeId: FloatingLabelInput!
    @IBOutlet weak var diameter: FloatingLabelInput!
    @IBOutlet weak var height: FloatingLabelInput!
    @IBOutlet weak var treeType: FloatingLabelInput!
    @IBOutlet weak var safeArea: FloatingLabelInput!
    @IBOutlet weak var treeDiscription: UITextView!
    @IBOutlet weak var sirenId: FloatingLabelInput!
    @IBOutlet weak var sirenInstallation: FloatingLabelInput!
    @IBOutlet weak var thresholdY: FloatingLabelInput!
    
    @IBOutlet weak var thresholdZ: FloatingLabelInput!
    
    @IBOutlet var validationLabels: [UILabel]!
    
    @IBOutlet weak var description_Underline: UILabel!
    
    @IBOutlet weak var descriptionError: UILabel!
    
    var drop = DropDown()
    
    var viewModal: PropertyViewModal = PropertyViewModal()
    var viewmodel: TreeTypeViewModel = TreeTypeViewModel()
    
    //
    var propertyList: [Property] = []
    var propertyArray = [String]()
    var propertyIdarray = [Int]()
    var proprtyid = Int()
    
    //
    var treeList : TreeData?
    var treeArray = [String]()
    
    //
    var GatewayArray = [String]()
    var gatewayIdarray = [Int]()
    var gateWayID = Int()
    var alarmId = String()
    //
    var clientId = Int()
    ///
    var intallDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        sirenInstallation.delegate = self
        treeDiscription.delegate = self
        treeDiscription.text = "Tree Description"
        treeDiscription.textColor = UIColor.lightGray
        getProperty()
        getTreeTypes()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    func setupUI(){
        
        deviceName.delegate = self
        deviceId.delegate = self
        selectProperty.delegate = self
        selectGateway.delegate = self
        treeId.delegate = self
        diameter.delegate = self
        height.delegate = self
        treeType.delegate = self
        safeArea.delegate = self
        sirenId.delegate = self
        sirenInstallation.delegate = self
        thresholdY.delegate = self
        thresholdZ.delegate = self
        
        deviceName.setUnderlineColor(color: .darkGray)
        deviceId.setUnderlineColor(color: .darkGray)
        selectProperty.setUnderlineColor(color: .darkGray)
        selectGateway.setUnderlineColor(color: .darkGray)
        treeId.setUnderlineColor(color: .darkGray)
        diameter.setUnderlineColor(color: .darkGray)
        height.setUnderlineColor(color: .darkGray)
        treeType.setUnderlineColor(color: .darkGray)
        safeArea.setUnderlineColor(color: .darkGray)
        sirenId.setUnderlineColor(color: .darkGray)
        sirenInstallation.setUnderlineColor(color: .darkGray)
        thresholdY.setUnderlineColor(color: .darkGray)
        thresholdZ.setUnderlineColor(color: .darkGray)
        
        deviceName.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        deviceId.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        selectProperty.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        selectGateway.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        treeId.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        diameter.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        height.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        treeType.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        safeArea.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        sirenId.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        sirenInstallation.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        thresholdY.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        thresholdZ.setPlaceHolderColor(color: UIColor.lightGray.withAlphaComponent(0.8))
        
        deviceName.floatingLabelColor = .lightGray
        deviceId.floatingLabelColor = .lightGray
        selectProperty.floatingLabelColor = .lightGray
        selectGateway.floatingLabelColor = .lightGray
        treeId.floatingLabelColor = .lightGray
        diameter.floatingLabelColor = .lightGray
        height.floatingLabelColor = .lightGray
        treeType.floatingLabelColor = .lightGray
        safeArea.floatingLabelColor = .lightGray
        sirenId.floatingLabelColor = .lightGray
        sirenInstallation.floatingLabelColor = .lightGray
        thresholdY.floatingLabelColor = .lightGray
        thresholdZ.floatingLabelColor = .lightGray
        
        deviceName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        deviceId.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        selectProperty.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        selectGateway.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        treeId.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        diameter.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        height.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        treeType.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        safeArea.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        sirenId.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        sirenInstallation.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        thresholdY.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        thresholdZ.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        validationLabels[0].tag = 0
        validationLabels[1].tag = 1
        validationLabels[2].tag = 2
        validationLabels[3].tag = 3
        validationLabels[4].tag = 4
        validationLabels[5].tag = 5
        validationLabels[6].tag = 6
        validationLabels[7].tag = 7
        validationLabels[8].tag = 8
        validationLabels[9].tag = 9
        validationLabels[10].tag = 10
        validationLabels[11].tag = 11
        validationLabels[12].tag = 12
        
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if treeDiscription.textColor == UIColor.lightGray {
            treeDiscription.text = nil
            descriptionError.text = ""
            description_Underline.backgroundColor = UIColor.darkGray
            treeDiscription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if treeDiscription.text.isEmpty {
            treeDiscription.text = "Tree Description"
            treeDiscription.textColor = UIColor.lightGray
        }
    }
    
    
    
    func setPropertyData(_ propertyList: [Property]) {
        self.propertyList = propertyList
        for i in 0..<propertyList.count{
            self.propertyArray.append(propertyList[i].name)
            self.propertyIdarray.append(propertyList[i].id)
            self.clientId = propertyList[i].clientId
        }
    }
    
    func getProperty(){
        viewModal.getPropertyAPI { [weak self] (propertyList, isSuccess) in
            guard isSuccess else { return }
            self?.setPropertyData(propertyList)
        }
    }
    
    
    func getTreeTypes(){
        viewmodel.treeType { [weak self] (treelist, isSuccess) in
            guard isSuccess else { return }
            guard let treeTypes = treelist?.treeTypes else {return}
            for i in 0..<treeTypes.count{
                self?.treeArray.append(treeTypes[i].displayName)
            }
            
        }
    }
    
    func isValid() -> Bool {
        
        if deviceName.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 0 {
                label.text = "Please enter device name"
                deviceName.becomeFirstResponder()
                deviceName.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if deviceId.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 1 {
                label.text = "Please enter Device ID"
                deviceId.becomeFirstResponder()
                deviceId.setUnderlineColor(color: .systemRed)
            }
            return false
        } else if selectProperty.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 2 {
                label.text = "Please Select Property"
                selectProperty.becomeFirstResponder()
                selectProperty.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if selectGateway.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 3 {
                label.text = "Please Select Gateway"
                selectGateway.becomeFirstResponder()
                selectGateway.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if treeId.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 4 {
                label.text = "Please Enter tree ID"
                treeId.becomeFirstResponder()
                treeId.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if diameter.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 5 {
                label.text = "Please enter diameter"
                diameter.becomeFirstResponder()
                diameter.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if height.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 6 {
                label.text = "Please enter height"
                height.becomeFirstResponder()
                height.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if treeType.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 7 {
                label.text = "Please enter Tree type"
                treeType.becomeFirstResponder()
                treeType.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if safeArea.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 8 {
                label.text = "Please enter Safe Area"
                safeArea.becomeFirstResponder()
                safeArea.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if treeDiscription.textColor == UIColor.lightGray {
            descriptionError.text = "Please Enter Description"
            description_Underline.backgroundColor = UIColor.systemRed
            return false
        }else if sirenId.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 9 {
                label.text = "Please enter Siren ID"
                sirenId.becomeFirstResponder()
                sirenId.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if sirenInstallation.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 10 {
                label.text = "Please enter Date"
                sirenInstallation.becomeFirstResponder()
                sirenInstallation.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if thresholdY.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 11 {
                label.text = "Please enter ThresHold Value"
                thresholdY.becomeFirstResponder()
                thresholdY.setUnderlineColor(color: .systemRed)
            }
            return false
        }else if thresholdZ.text?.trim().count == 0 {
            for label in validationLabels where label.tag == 12 {
                label.text = "Please enter ThresHold Value"
                thresholdZ.becomeFirstResponder()
                thresholdZ.setUnderlineColor(color: .systemRed)
            }
            return false
        }
        else {
            return true
        }
    }
    
    
//MARK: - ACTION
    @IBAction func onAddTreeTiltTap(_ sender: Any) {
            guard isValid() else {return}
            addTreeSirenApi()
    }
    
    
    @IBAction func onSirenInstallationTap(_ sender: Any) {
        datePicker()
    }
    
    
    @IBAction func onSelectSirenIdTap(_ sender: Any) {
        drop.dataSource = ["External siren"]
        drop.anchorView = self.sirenId
        drop.show()
        drop.selectionAction = { [unowned self] (index, item) in
            self.sirenId.text = item
            sirenId.text = item
            validationLabels[9].text = ""
            sirenId.setUnderlineColor(color: .darkGray)
        }
    }
    
    
    @IBAction func onSelectTreeTypeTap(_ sender: Any) {
        drop.dataSource = treeArray
        drop.anchorView = self.treeType
        drop.show()
        drop.selectionAction = { [unowned self] (index, item) in
            self.treeType.text = item
            treeType.text = item
            validationLabels[7].text = ""
            treeType.setUnderlineColor(color: .darkGray)

        }
    }
    
    @IBAction func onSelectGatewayTap(_ sender: Any) {[self]
        drop.dataSource = GatewayArray
        drop.anchorView = self.selectGateway
        drop.show()
        drop.selectionAction = { [unowned self] (index, item) in
            self.selectGateway.text = item
            self.gateWayID = gatewayIdarray[index]
            validationLabels[3].text = ""
            selectGateway.setUnderlineColor(color: .darkGray)
            let queryString = "offset=\(0)" + "&propertyId=\(proprtyid)"+"&endDeviceType=alarm_siren"+"&gatewayId=\(gateWayID)"+"&clientId=\(clientId)"
            APIServices.shared.getEndDeveiceIdApi(queryString) { response, isSuccess in
                if isSuccess{
                   let dataRecord = response["records"] as! [AnyObject]
                    for i in 0..<dataRecord.count{
                        let alarmData = dataRecord[i]["alarmSiren"] as! NSDictionary
                        alarmId = alarmData.object(forKey: "sirenId") as? String ?? ""
                    }
                }else{
                    print("dfdf")
                }
            }
            
        }
    }
    
    @IBAction func onSelectPropertyTap(_ sender: Any) {
        drop.dataSource = propertyArray
        drop.anchorView = self.selectProperty
        drop.show()
        drop.selectionAction = { [unowned self] (index, item) in
            selectProperty.text = item
            proprtyid = propertyIdarray[index]
            validationLabels[2].text = ""
            selectProperty.setUnderlineColor(color: .darkGray)
            viewmodel.getGateway(propertyID: "\(proprtyid)") { gatewaydata, isSuccess in
                guard isSuccess else { return }
                guard let records = gatewaydata?.records else {return}
                for i in 0..<records.count{
                    self.GatewayArray.append(records[i].deviceId)
                    self.gatewayIdarray.append(records[i].id)
                }
            }
            
        }
    }
    
    
    func addTreeSirenApi(){ [self]
        
        var treeTyp = ""
        if treeType.text == "Evergreen Conifer"{
            treeTyp = "evergreen_conifer"
        }else{
            treeTyp = "deciduous_broadleaf"
        }
        
        let treeTiltSensor:[String:Any] = [
            "treeId": treeId.text!,
            "treeType": treeTyp,
            "treeHeight": Int(height.text!) ?? 0,
            "dbh": Int(diameter.text!) ?? 0,
            "safeZoneArea": Int(safeArea.text!) ?? 0,
            "alarmSirenIds": [781],
            "upperY": Int(thresholdY.text!) ?? 0,
            "lowerY": Int("-\(thresholdY.text!)") ?? 0,
            "upperZ": Int(thresholdZ.text!) ?? 0,
            "lowerZ": Int("-\(thresholdZ.text!)") ?? 0
        ]
        let para: [String:Any] = [
            "deviceId": deviceId.text!,
            "propertyId": proprtyid,
            "gatewayId": gateWayID,
            "installationDate": intallDate,
            "description": treeDiscription.text!,
            "name": deviceName.text!,
            "endDeviceType": "tree_tilt_sensor",
            "clientId":clientId,
            "deviceState": 1,
            "treeTiltSensor": treeTiltSensor
        ]
        print("fsdf")
        print(para)
        print("fsdf")
        CommonMethods.showProgressHud(inView: view)
        APIServices.shared.createEndDevice(param: para) { response, isSuccess in
            CommonMethods.hideProgressHud()
            if isSuccess{
                self.navigationController?.popViewController(animated: true)
            }
            else{
//                print(response)
                
            }
        }
        
    }
    
    @IBAction func onBacktap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - DATE PICKER
extension AddTreeTiltDeviceVC{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePicker()
    }
    
    func datePicker(){
        let datepick = UIDatePicker()
        datepick.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datepick.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        sirenInstallation.inputView = datepick

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        
        let flexiblebtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelBtn,flexiblebtn,doneBtn], animated: false)
        sirenInstallation.inputAccessoryView = toolbar
    }
    
    @objc func cancel(){
        self.sirenInstallation.resignFirstResponder()
    }
    
    
    @objc func done(){
        if let datePicker = sirenInstallation.inputView as? UIDatePicker{
            datePicker.datePickerMode = .date
            let dateformatter  = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy"
            sirenInstallation.text = dateformatter.string(from: datePicker.date)
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss:SSS'Z'"
            intallDate = dateformatter.string(from: datePicker.date)
            self.sirenInstallation.setUnderlineColor(color: .lightGray)
            self.validationLabels[10].text = ""
            self.sirenInstallation.resignFirstResponder()

        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    /// To get editing changed event of Textfields.
    @objc func textFieldDidChange(_ textField: UITextField) {
        var selectedTextField: Int = 0
        switch textField {
        case deviceName:
            selectedTextField = 0
            deviceName.setUnderlineColor(color: .darkGray)
        case deviceId:
            selectedTextField = 1
            deviceId.setUnderlineColor(color: .darkGray)
        case selectProperty:
            selectedTextField = 2
            selectProperty.setUnderlineColor(color: .darkGray)
        case selectGateway:
            selectedTextField = 3
            selectGateway.setUnderlineColor(color: .darkGray)
        case treeId:
            selectedTextField = 4
            treeId.setUnderlineColor(color: .darkGray)
        case diameter:
            selectedTextField = 5
            diameter.setUnderlineColor(color: .darkGray)
        case height:
            selectedTextField = 6
            height.setUnderlineColor(color: .darkGray)
        case treeType:
            selectedTextField = 7
            treeType.setUnderlineColor(color: .darkGray)
        case safeArea:
            selectedTextField = 8
            safeArea.setUnderlineColor(color: .darkGray)
        case sirenId:
            selectedTextField = 9
            sirenId.setUnderlineColor(color: .darkGray)
        case sirenInstallation:
            selectedTextField = 10
            sirenInstallation.setUnderlineColor(color: .darkGray)
        case thresholdY:
            selectedTextField = 11
            thresholdY.setUnderlineColor(color: .darkGray)
        case thresholdZ:
            selectedTextField = 12
            thresholdZ.setUnderlineColor(color: .darkGray)
        default: break }
        for label in validationLabels where label.tag == selectedTextField {
            label.text = ""
        }
    }
        
}
