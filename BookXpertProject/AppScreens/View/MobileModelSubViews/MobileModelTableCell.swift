//
//  MobileModelTableCell.swift
//  BookXpertProject
//
//  Created by CredoUser on 24/04/25.
//

import UIKit

protocol MobileModelCellDelegate{
    func deleteMobileModel(indexPos: Int, data:MobileModelList, name:String)
}

class MobileModelTableCell: UITableViewCell {
    class var identifier: String{return String(describing: self)}
    class var nibName: UINib{ return UINib(nibName: identifier, bundle: nil)}
    
    var delegate:MobileModelCellDelegate?
    var mobileModelData:MobileModelList?

    @IBOutlet weak var bgViewOL: BorderView!
    @IBOutlet weak var nameLblOL: UILabel!
    @IBOutlet weak var deleteControlOL: UIControl!
    @IBOutlet weak var deleteImgOL: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func didTapDelete(_ sender: UIControl) {
        if let delegate = self.delegate, let data = self.mobileModelData{
            delegate.deleteMobileModel(indexPos: sender.tag, data: data, name: data.name ?? "")
        }
    }
    
//    func mobileModelListCellConfig(data: MobileModelListModel){
    func mobileModelListCellConfig(data: MobileModelList){
        self.mobileModelData = data
        self.nameLblOL.text = data.name
    }
}
