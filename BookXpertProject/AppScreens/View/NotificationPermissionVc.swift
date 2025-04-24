//
//  NotificationPermissionVc.swift
//  BookXpertProject


import UIKit

class NotificationPermissionVc: UIViewController {

    @IBOutlet weak var backNaviViewOL: BackNavigationSubView!{
        didSet{
            self.backNaviViewOL.delegate = self
        }
    }
    @IBOutlet weak var permissionSwitvhOL: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkNotificationPermission()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appDidBecomeActive() {
        self.checkNotificationPermission()
    }

    
    @IBAction func didChangeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    if settings.authorizationStatus == .denied {
                        sender.isOn = false
                        self.showSettingsAlert()
                    } else {
                        UserDefault.shared.setAllowNotificationService(permission: true)
                    }
                }
            }
        } else {
            UserDefault.shared.setAllowNotificationService(permission: false)
        }
    }
    
    func uiSetUp(){
        self.backNaviViewOL.titleCommonUISetup(titleTxt: "Notification")
        self.permissionSwitvhOL.isOn = UserDefault.shared.getAllowNotificationService()
    }
    
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    self.permissionSwitvhOL.isOn = true
                    UserDefault.shared.setAllowNotificationService(permission: true)
                case .denied, .notDetermined:
                    self.permissionSwitvhOL.isOn = false
                    UserDefault.shared.setAllowNotificationService(permission: false)
                @unknown default:
                    self.permissionSwitvhOL.isOn = false
                }
            }
        }
    }
    
    func notificationAlert(isAllowed:Bool){
        var alertMsg: String = "Notification Service Permission Denied"
        if isAllowed{
            alertMsg = "Notification Service Permission Allowed"
        }
        self.showToast(message: alertMsg)
    }
    
    func showSettingsAlert() {
        let alert = UIAlertController(title: "Notifications Disabled",
                                      message: "Please enable notifications in Settings to receive updates.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        self.present(alert, animated: true)
    }
    

}

extension NotificationPermissionVc: BackNavigationSubViewDelegate{
    func backIconPressed(isPressed:Bool){
        self.navigationController?.popViewController(animated: true)
    }
}
