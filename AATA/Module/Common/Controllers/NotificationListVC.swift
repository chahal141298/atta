//
//  NotificationListVC.swift
//  AATA
//
//  Created by Uday Patel on 04/10/21.
//

import UIKit

///
class NotificationListVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    ///
    @IBOutlet weak var notificationTable: UITableView!
    
    // MARK: - Variables
    ///
    var dataSource: NotificationDataSource?
    ///
    lazy var emptyDatasource: EmptyDataSource = EmptyDataSource()
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonMethods.showProgressHud(inView: self.view)
        getAlertList()
    }
    
    // MARK: - Helper Methods
    ///
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
        }
    }
    
    ///
    func setupDataSource() {
        dataSource = NotificationDataSource.init(withTableView: notificationTable)
        dataSource?.delegate = self
    }
    
    ///
    func reloadEmptyDataSource() {
        emptyDatasource.placeholderMessage = R.string.localizable.dataNotFound()
        notificationTable.delegate = emptyDatasource
        notificationTable.reloadData()
    }
    
    func releadDara(_ alertList: [Alert]) {
        dataSource?.alertList = alertList
        notificationTable.reloadData()
    }
    
    // MARK: - Action Methods
    ///
    @IBAction func onBackTap(_ sender: Any) {
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    // MARK: - API Methods
    ///
    func getAlertList() {
        guard let propertyId = Constants.selectedProperty?.id else { return }
        APIServices.shared.getAlertAPI("\(propertyId)", { [weak self] (alertList, isSuccess) in
            CommonMethods.hideProgressHud()
            self?.dataSource?.endRefreshing()
            guard isSuccess else { return }
            if alertList.count > 0 {
                self?.releadDara(alertList)
            } else {
                self?.reloadEmptyDataSource()
            }
        })
    }
}

///
extension NotificationListVC: NotificationDelegate {
    ///
    func deleteAlert(_  alertDetail: Alert) {
        CommonMethods.showProgressHud(inView: self.view)
        APIServices.shared.deleteAlertAPI("\(alertDetail.id)") { response, isSuccess in
            if isSuccess {
                self.getAlertList()
            } else {
                CommonMethods.hideProgressHud()
            }
        }
    }
    
    ///
    func refreshData() {
        getAlertList()
    }
    
}
