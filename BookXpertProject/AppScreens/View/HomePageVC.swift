//
//  HomePageVC.swift
//  BookXpertProject

import UIKit

class HomePageVC: UIViewController {
    
    @IBOutlet weak var appLogoImgOL: UIImageView!
    @IBOutlet weak var logoutViewOL: UIControl!
    @IBOutlet weak var logoutImgOL: UIImageView!
    @IBOutlet weak var listTableviewOL: UITableView!{
        didSet {
            self.listTableviewOL.delegate = self
            self.listTableviewOL.dataSource = self
            self.listTableviewOL.register(HomeListTableCell.nibName, forCellReuseIdentifier: HomeListTableCell.identifier)
            self.listTableviewOL.separatorStyle = .singleLine
        }
    }
    
    lazy var googleSignInClass: GoogleSignInClass = {
        return GoogleSignInClass()
    }()
    var homeListData: [HomeListDataModel] = [
        HomeListDataModel(description: "PDF View", imageName: "", listCode: .pdfView),
        HomeListDataModel(description: "Gallery View", imageName: "", listCode: .gallery),
        HomeListDataModel(description: "Mobile Model", imageName: "", listCode: .mobileModel),
        HomeListDataModel(description: "Notification", imageName: "", listCode: .notification),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiSetup()
    }
    
    @IBAction func didTapLogOut(_ sender: UIControl) {
        self.presentAlert(title: "Alert", message: "Are you sure you want to log out?")
    }
    
    func presentAlert(title:String, message:String){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { _ in
            self.logoutCall()
        })
        self.present(alert, animated: true)
    }
    
    func uiSetup(){
        if let appLogoImg = UIImage(named: "bookExpertLog"){
            self.appLogoImgOL.image = appLogoImg
        }
        if let logOutImg = UIImage(systemName: "rectangle.portrait.and.arrow.right"){
            self.logoutImgOL.image = logOutImg
        }
    }
    
    func logoutCall(){
        self.googleSignInClass.signOutFromGoogle { success, message, error in
            if success{
                UserDefault.shared.resetUserDefault()
                self.navigateToSigInPage()
            } else {
                // Optionally show an error alert
                let errorAlert = UIAlertController(title: "Error",
                                                   message: message ?? "Logout failed.",
                                                   preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(errorAlert, animated: true)
            }
        }
    }
    
    func navigateToSigInPage(){
        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let rootVC = mainStroyboard.instantiateViewController(withIdentifier: "SignInOptionVC") as? SignInOptionVC else {
            return
        }
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    
}

extension HomePageVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HomeListTableCell.identifier, for: indexPath) as? HomeListTableCell{
            cell.homeListCellConfig(configData: self.homeListData[indexPath.row])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigateToScreens(code: self.homeListData[indexPath.row].listCode)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension HomePageVC{ //MARK: Navigate To Screens
    func navigateToScreens(code: HomeListCode){
        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc:UIViewController?
        
        switch code {
        case .pdfView:
            vc = mainStroyboard.instantiateViewController(withIdentifier: "PdfDisplayVC") as? PdfDisplayVC
        case .gallery:
            vc = mainStroyboard.instantiateViewController(withIdentifier: "GalleryImageVC") as? GalleryImageVC
        case .mobileModel:
            vc = mainStroyboard.instantiateViewController(withIdentifier: "MobileModelListVC") as? MobileModelListVC
        case .notification:
            vc = mainStroyboard.instantiateViewController(withIdentifier: "NotificationPermissionVc") as? NotificationPermissionVc
        default:
            break
        }
        guard let navigateVC = vc else {
            return
        }
        vc?.hidesBottomBarWhenPushed = true
        vc?.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(navigateVC, animated: true)
    }
    
    
    
}
