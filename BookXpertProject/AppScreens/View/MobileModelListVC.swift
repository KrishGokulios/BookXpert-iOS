//
//  MobileModelListVC.swift
//  BookXpertProject


import UIKit

class MobileModelListVC: UIViewController {
    
    @IBOutlet weak var backNaviViewOL: BackNavigationSubView!{
        didSet{
            self.backNaviViewOL.delegate = self
        }
    }
    @IBOutlet weak var listTableviewOL: UITableView!{
        didSet {
            self.listTableviewOL.delegate = self
            self.listTableviewOL.dataSource = self
            self.listTableviewOL.register(MobileModelTableCell.nibName, forCellReuseIdentifier: MobileModelTableCell.identifier)
            self.listTableviewOL.separatorStyle = .singleLine
        }
    }
    
    var viewModel:SignInViewModel = {
        return SignInViewModel()
    }()
    lazy var coreDataClass: AppCoreDataClass = {
        return AppCoreDataClass()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backNaviViewOL.titleCommonUISetup(titleTxt: "Mobile List")
        self.getingMobileListFromCoreData()
//        self.getMobileListApiCall()
    }
    
    func getingMobileListFromCoreData(){
        self.viewModel.fetchMobileModelData { success, message in
            if success{
                self.listTableviewOL.reloadData()
            }else{
                self.getMobileListApiCall()
            }
        }
    }
    
    func navigateToMobileBriefPage(data:MobileModelList){
        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc =  mainStroyboard.instantiateViewController(withIdentifier: "MobileModelUpdateBriefVC") as? MobileModelUpdateBriefVC{
            vc.recMobileModelData = data
            vc.hidesBottomBarWhenPushed = true
            vc.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension MobileModelListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.mobileModelListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MobileModelTableCell.identifier, for: indexPath) as? MobileModelTableCell{
            cell.delegate = self
            cell.deleteControlOL.tag = indexPath.row
            cell.mobileModelListCellConfig(data: self.viewModel.mobileModelListData[indexPath.row])
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigateToMobileBriefPage(data: self.viewModel.mobileModelListData[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension MobileModelListVC{ //MARK: API Call
    func getMobileListApiCall(){
        if(NetworkConnectivity.isConnectedToInternet) {
            self.showLoader()
            self.viewModel.getMobileModelListApi { success, response, error in
                if success{
                    self.listTableviewOL.reloadData()
                    self.getingMobileListFromCoreData()
                }
                self.hideLoader()
            }
        }
    }
}

extension MobileModelListVC: BackNavigationSubViewDelegate{
    func backIconPressed(isPressed:Bool){
        self.navigationController?.popViewController(animated: true)
    }
}

extension MobileModelListVC: MobileModelCellDelegate{
    func deleteMobileModel(indexPos: Int,data:MobileModelList){
        print("Delete Mobile Model \(indexPos): \(data)")
        self.coreDataClass.deleteMobileModel(data) { success, message, error in
            self.viewModel.mobileModelListData.remove(at: indexPos)
            self.listTableviewOL.reloadData()
            if UserDefault.shared.getAllowNotificationService(){
                self.viewModel.sendFCMNotificationMethod(title: data.name ?? "" , body: "Mobile Model Deleted", itemId: data.id ?? "") { success in
                    if success{
                        print("Notification Sent Successfully")
                    }else{
                        print("Notification Sending Failed")
                    }
                }
            }
        }
    }
}
