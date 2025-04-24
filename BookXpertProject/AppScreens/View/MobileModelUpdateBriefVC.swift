//
//  MobileModelUpdateBriefVC.swift
//  BookXpertProject

import UIKit
import CoreData

class MobileModelUpdateBriefVC: UIViewController {
    
    @IBOutlet weak var backNaviViewOL: BackNavigationSubView!{
        didSet{
            self.backNaviViewOL.delegate = self
        }
    }
    @IBOutlet weak var detailsTableviewOL: UITableView!{
        didSet {
            self.detailsTableviewOL.delegate = self
            self.detailsTableviewOL.dataSource = self
            self.detailsTableviewOL.register(MobileModelEditTableCell.nibName, forCellReuseIdentifier: MobileModelEditTableCell.identifier)
            self.detailsTableviewOL.separatorStyle = .none
        }
    }
    @IBOutlet weak var editButtonOL: UIButton!
    @IBOutlet weak var updateViewOL: UIControl!
    @IBOutlet weak var updateLblOL: UILabel!
    
    lazy var coreDataClass: AppCoreDataClass = {
        return AppCoreDataClass()
    }()
    var recMobileModelData:MobileModelList?
    var modifyMobileModelData:MobileModelList?
    
    var mobileListData:[MobileModelEditModel] = [MobileModelEditModel]()
    
    var allowUserToEdit:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backNaviViewOL.titleCommonUISetup(titleTxt: "Mobile List")
        self.modifyMobileModelData = self.recMobileModelData
        self.allowUserToEdit = false
        self.uiSetup()
        
    }
    
    func uiSetup(){
        self.mobileListData = [MobileModelEditModel(title: "Name", description: modifyMobileModelData?.name ?? "", code: .name),
                              MobileModelEditModel(title: "CapacityGB", description: modifyMobileModelData?.dataCapacity ?? "", code: .capacityGB),
                              MobileModelEditModel(title: "Price", description: modifyMobileModelData?.price ?? "", code: .capacityGB),
                              MobileModelEditModel(title: "Generation", description: modifyMobileModelData?.generation ?? "", code: .generation),
                              MobileModelEditModel(title: "Capacity", description: modifyMobileModelData?.capacity ?? "", code: .capacity),
                              MobileModelEditModel(title: "DescriptionData", description: modifyMobileModelData?.descriptionData ?? "", code: .descriptionData),
                              MobileModelEditModel(title: "DataColor", description: modifyMobileModelData?.dataColor ?? "", code: .dataColor),
                              MobileModelEditModel(title: "DataCapacity", description: modifyMobileModelData?.dataCapacity ?? "", code: .dataCapacity),
                              MobileModelEditModel(title: "DataPrice", description: "\(modifyMobileModelData?.dataPrice ?? 0)", code: .dataPrice),
                              MobileModelEditModel(title: "DataGeneration", description: modifyMobileModelData?.dataGeneration ?? "", code: .dataGeneration),
                              MobileModelEditModel(title: "Year", description: "\(modifyMobileModelData?.year ?? 0)", code: .year),
                              MobileModelEditModel(title: "CPU Model", description: modifyMobileModelData?.cpuModel ?? "", code: .cpuModel),
                              MobileModelEditModel(title: "Hard Disk Size", description: modifyMobileModelData?.hardDiskSize ?? "", code: .hardDiskSize),
                              MobileModelEditModel(title: "Strap Colour", description: modifyMobileModelData?.strapColour ?? "", code: .strapColour),
                              MobileModelEditModel(title: "Case Size", description: modifyMobileModelData?.caseSize ?? "", code: .caseSize),
                              MobileModelEditModel(title: "Color", description: modifyMobileModelData?.color ?? "", code: .color),
                              MobileModelEditModel(title: "Screen Size", description: "\(modifyMobileModelData?.screenSize ?? 0)", code: .screenSize)
        ]
        self.detailsTableviewOL.reloadData()
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        self.allowUserToEdit.toggle()
        if self.allowUserToEdit{
            self.editButtonOL.setTitle("", for: .normal)
            self.editButtonOL.isUserInteractionEnabled = false
        }
        self.detailsTableviewOL.reloadData()
    }
    
    @IBAction func didTapUpdateView(_ sender: UIControl) {
        if self.allowUserToEdit{
            self.updateMobileModelData()
        }
    }
    
    func updateMobileModelData(){
        if let data = self.recMobileModelData, let changedData = self.modifyMobileModelData{
            self.coreDataClass.updateMobileModelData(data, with: changedData) { success, message, error in
                if success{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showToast(message: "Mobile Details Updation Failed")
                }
            }
        }
    }

}

extension MobileModelUpdateBriefVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mobileListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MobileModelEditTableCell.identifier, for: indexPath) as? MobileModelEditTableCell{
            cell.delegate = self
            cell.enterTxtOL.tag = indexPath.row
            cell.editDetailsCellConfig(allowEdit: self.allowUserToEdit, title: mobileListData[indexPath.row].title, code: mobileListData[indexPath.row].code, txtDisp: mobileListData[indexPath.row].description)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension MobileModelUpdateBriefVC: BackNavigationSubViewDelegate{
    func backIconPressed(isPressed:Bool){
        self.navigationController?.popViewController(animated: true)
    }
}

extension MobileModelUpdateBriefVC: MobileModelEditTableCellDelegate{
    func didChangeText(code: EditMobileDetailCode, indexPos: Int, text: String) {
        self.mobileListData[indexPos].description = text
        switch code{
        case .name:
            self.modifyMobileModelData?.name = text
        case .dataColor:
            self.modifyMobileModelData?.dataColor = text
        case .dataCapacity:
            self.modifyMobileModelData?.dataCapacity = text
        case .capacityGB:
            self.modifyMobileModelData?.capacityGB = Int64(Int(text)  ?? 0)
        case .dataPrice:
            self.modifyMobileModelData?.dataPrice = Double(text) ?? 0
        case .dataGeneration:
            self.modifyMobileModelData?.dataGeneration = text
        case .year:
            self.modifyMobileModelData?.year = Int64(Int(text)  ?? 0)
        case .cpuModel:
            self.modifyMobileModelData?.cpuModel = text
        case .hardDiskSize:
            self.modifyMobileModelData?.hardDiskSize = text
        case .strapColour:
            self.modifyMobileModelData?.strapColour = text
        case .caseSize:
            self.modifyMobileModelData?.caseSize = text
        case .color:
            self.modifyMobileModelData?.color = text
        case .descriptionData:
            self.modifyMobileModelData?.descriptionData = text
        case .capacity:
            self.modifyMobileModelData?.capacity = text
        case .screenSize:
            self.modifyMobileModelData?.screenSize = Double(text) ?? 0
        case .generation:
            self.modifyMobileModelData?.generation = text
        case .price:
            self.modifyMobileModelData?.price = text
        default:
            break
        }
    }
}
