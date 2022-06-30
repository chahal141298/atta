//
//  SettingsVC.swift
//  AATA
//
//  Created by Uday Patel on 21/09/21.
//

import UIKit

///
class SettingsVC: UIViewController {
    // MARK: - IBOutlet
    ///
    @IBOutlet weak var baseView: ScrollableTabView!
    ///
    @IBOutlet weak var bottomRoundCornerView: UIView!
    
    // MARK: - Variables
    ///
    var dataSource: ScrollableTabMenu?
    /// This index is for selected scrollable manu.
    var selectedPageIndex: Int = 0
    
    // MARK: - Controller Life Cycle
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addObserver()
    }
    
    ///
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    ///
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        removeObserver()
    }
    
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helper Methods
    ///
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomRoundCornerView.roundCorners([.bottomLeft, .bottomRight], radius: 40)
        }
        setupScrollableTabMenu()
    }
    
    ///
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showLoader), name: .showLoader, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideLoader), name: .hideLoader, object: nil)
    }
    
    ///
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    ///
    @objc func showLoader() {
        CommonMethods.showProgressHud(inView: view)
    }
    
    ///
    @objc func hideLoader() {
        CommonMethods.hideProgressHud()
    }
    
    ///
    func setupScrollableTabMenu() {
        var controllers: [UIViewController] = []
        for i in 0 ... 1 {
            guard let controller = R.storyboard.settings.settingsListVC() else { continue }
            if (i == 0) {
                controller.settingsType = .profile
            } else if (i == 1) {
                controller.settingsType = .userManagement
            } else {
                controller.settingsType = .sirenSettings
            }
            // controller.delegate = self
            // controller.zoneId = zoneId
            // controller.deviceType = i == 0 ? .hub : .sensor
            // controller.selectedProperty = selectedProperty
            // controller.parentNavigationController = self.navigationController
            controllers.append(controller)
            
        }
        DispatchQueue.main.async {
            self.dataSource = ScrollableTabMenu.init(with: self.baseView, dataArray: [["name": SettingsType.profile.rawValue], ["name": SettingsType.userManagement.rawValue], ["name": SettingsType.sirenSettings.rawValue]], controller: self, innerControllers: controllers)
            self.baseView.delegate = self
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
}

///
extension SettingsVC: ScrollingTabViewDelegate {
    ///
    func scrollableTabView(_ scrollingTabView: ScrollableTabView, didChangePageTo index: Int) {
        selectedPageIndex = index
    }
    
    ///
    func scrollableTabView(_ scrollingTabView: ScrollableTabView, didScrollPageTo index: Int) {
        selectedPageIndex = index
    }
}
